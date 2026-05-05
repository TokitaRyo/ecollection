import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:pedometer/pedometer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'api_service.dart';
import 'user_session.dart';

/// Suit la progression d'une quête active selon son `metricType`
/// (steps / altitude / distance_from_home) et pousse la progression
/// au backend via /tasks/progress avec un throttle.
///
/// Surveille en permanence la vitesse GPS — si elle dépasse 30 km/h,
/// la quête est annulée automatiquement (anti-triche en voiture).
class TaskTracker {
  /// Vitesse max autorisée (30 km/h en m/s).
  static const double speedLimitMs = 30 / 3.6;

  /// Nombre de lectures GPS consécutives au-dessus de la limite avant
  /// d'annuler — protège contre les faux positifs du GPS au démarrage.
  static const int speedViolationsToCancel = 3;

  static StreamSubscription<StepCount>? _stepsSub;
  static StreamSubscription<Position>? _positionSub;
  static Timer? _throttle;

  static String? _currentTaskId;
  static String? _currentMetricType;
  static int _baseProgress = 0;
  static int _latestProgress = 0;
  static bool _hasPending = false;

  // Callbacks UI
  static VoidCallback? onTaskCompleted;
  static VoidCallback? onTaskAutoCancelled;

  // Steps
  static int? _stepCountAtStart;

  // Altitude / distance — on garde le max atteint
  static int _maxValue = 0;

  // Compteur de violations de vitesse consécutives
  static int _speedViolations = 0;

  /// Progression la plus récente captée localement, ou null si pas en cours.
  static int? currentProgress(String taskId) {
    if (_currentTaskId == taskId) return _latestProgress;
    return null;
  }

  /// Démarre le suivi pour la tâche active (idempotent si même taskId).
  static Future<void> start(Map<String, dynamic> activeTask) async {
    final taskId = activeTask['taskId'] as String?;
    if (taskId == null) return;
    if (_currentTaskId == taskId) return;

    await stop();

    final metricType = activeTask['metricType'] as String? ?? 'steps';
    final progress = (activeTask['progress'] ?? 0) as int;

    _currentTaskId = taskId;
    _currentMetricType = metricType;
    _baseProgress = progress;
    _latestProgress = progress;
    _maxValue = progress;
    _stepCountAtStart = null;

    // Garde l'écran allumé pendant la quête
    try {
      await WakelockPlus.enable();
    } catch (e) {
      debugPrint('Wakelock enable error: $e');
    }

    // Stream GPS commun à toutes les quêtes :
    //  - surveille la vitesse (anti-triche)
    //  - alimente la progression pour altitude / distance
    //  - sur Android, utilise un foreground service pour continuer en background
    final locOk = await _request(Permission.locationWhenInUse);
    if (locOk) {
      // Tente d'obtenir aussi la permission "Always" pour le background.
      // Si refusé, le foreground service marche quand même tant que la
      // notification reste affichée.
      await _request(Permission.locationAlways);

      final settings = Platform.isAndroid
          ? AndroidSettings(
              accuracy: LocationAccuracy.high,
              distanceFilter: 5,
              foregroundNotificationConfig: const ForegroundNotificationConfig(
                notificationTitle: 'Ecollection',
                notificationText: 'Suivi de votre quête en cours',
                enableWakeLock: true,
                setOngoing: true,
              ),
            )
          : const LocationSettings(
              accuracy: LocationAccuracy.high,
              distanceFilter: 5,
            );

      _positionSub = Geolocator.getPositionStream(locationSettings: settings)
          .listen(_handlePosition, onError: (e) => debugPrint('Geolocator error: $e'));
    } else {
      debugPrint('TaskTracker: LOCATION refusée');
    }

    // Stream podomètre uniquement pour les quêtes "steps".
    if (metricType == 'steps') {
      final actOk = await _request(Permission.activityRecognition);
      if (actOk) {
        _stepsSub = Pedometer.stepCountStream.listen(
          _handleSteps,
          onError: (e) => debugPrint('Pedometer error: $e'),
        );
      } else {
        debugPrint('TaskTracker: ACTIVITY_RECOGNITION refusée');
      }
    }
  }

  static Future<void> stop() async {
    await _stepsSub?.cancel();
    await _positionSub?.cancel();
    _stepsSub = null;
    _positionSub = null;
    _throttle?.cancel();
    _throttle = null;
    _currentTaskId = null;
    _currentMetricType = null;
    _baseProgress = 0;
    _latestProgress = 0;
    _maxValue = 0;
    _hasPending = false;
    _stepCountAtStart = null;
    _speedViolations = 0;
    try {
      await WakelockPlus.disable();
    } catch (e) {
      debugPrint('Wakelock disable error: $e');
    }
  }

  // ============================================
  // Handlers
  // ============================================

  static void _handlePosition(Position pos) {
    // Anti-triche : 3 lectures GPS consécutives > 30 km/h → annulation auto
    if (pos.speed.isFinite && pos.speed > speedLimitMs) {
      _speedViolations++;
      debugPrint(
        'TaskTracker: speed=${pos.speed.toStringAsFixed(2)}m/s '
        '(${(pos.speed * 3.6).toStringAsFixed(1)}km/h) '
        'violations=$_speedViolations/$speedViolationsToCancel',
      );
      if (_speedViolations >= speedViolationsToCancel) {
        _autoCancelForSpeed();
        return;
      }
    } else {
      _speedViolations = 0;
    }

    // Suivi métrique pour altitude / distance
    switch (_currentMetricType) {
      case 'altitude':
        final alt = pos.altitude.toInt();
        if (alt > _maxValue) {
          _maxValue = alt;
          _enqueue(_maxValue);
        }
        break;
      case 'distance_from_home':
        final session = UserSession();
        final homeLat = session.homeLatitude;
        final homeLon = session.homeLongitude;
        if (homeLat == null || homeLon == null) break;
        final distance = Geolocator.distanceBetween(
          homeLat,
          homeLon,
          pos.latitude,
          pos.longitude,
        ).toInt();
        if (distance > _maxValue) {
          _maxValue = distance;
          _enqueue(_maxValue);
        }
        break;
    }
  }

  static void _handleSteps(StepCount event) {
    // Le pedometer renvoie un cumul depuis le boot — on capture la valeur
    // initiale au premier event en tenant compte du progrès déjà sauvegardé.
    _stepCountAtStart ??= event.steps - _baseProgress;
    final progress = event.steps - (_stepCountAtStart ?? event.steps);
    _enqueue(progress);
  }

  // ============================================
  // Auto-cancel
  // ============================================

  static Future<void> _autoCancelForSpeed() async {
    final taskId = _currentTaskId;
    if (taskId == null) return;
    debugPrint('TaskTracker: vitesse > 30 km/h, annulation automatique de $taskId');

    // Stop d'abord pour éviter une cascade d'annulations
    await stop();
    try {
      await ApiService.cancelTask(taskId);
    } catch (e) {
      debugPrint('Auto-cancel API error: $e');
    }
    onTaskAutoCancelled?.call();
  }

  // ============================================
  // Throttle + push API
  // ============================================

  static void _enqueue(int progress) {
    _latestProgress = progress;
    _hasPending = true;
    _throttle ??= Timer.periodic(const Duration(seconds: 5), (_) => _flush());
  }

  static Future<void> _flush() async {
    if (!_hasPending || _currentTaskId == null) return;
    _hasPending = false;
    final taskId = _currentTaskId!;
    final progress = _latestProgress;
    try {
      final result = await ApiService.updateProgress(
        taskId: taskId,
        progress: progress,
      );
      if (result['completed'] == true) {
        await stop();
        onTaskCompleted?.call();
      }
    } catch (e) {
      debugPrint('TaskTracker push error: $e');
    }
  }

  static Future<bool> _request(Permission p) async {
    final status = await p.request();
    return status.isGranted;
  }
}
