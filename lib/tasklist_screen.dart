import 'dart:async';
import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'services/task_tracker.dart';
import 'services/user_session.dart';
import 'widgets/shared_widgets.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<dynamic> _tasks = [];
  List<dynamic> _activeTasks = [];
  bool _loading = true;

  Timer? _ticker;
  Timer? _refreshTimer;
  DateTime? _deadline;

  @override
  void initState() {
    super.initState();
    TaskTracker.onTaskCompleted = _onTaskCompleted;
    TaskTracker.onTaskAutoCancelled = _onTaskAutoCancelled;
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && _activeTasks.isNotEmpty) setState(() {});
    });
    _refreshTimer = Timer.periodic(const Duration(minutes: 10), (_) {
      _loadData(silent: true);
    });
    _loadData();
  }

  void _onTaskAutoCancelled() {
    if (!mounted) return;
    _loadData();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Mission annulée : déplacement trop rapide détecté (> 30 km/h)',
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 4),
      ),
    );
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _refreshTimer?.cancel();
    TaskTracker.onTaskCompleted = null;
    TaskTracker.onTaskAutoCancelled = null;
    super.dispose();
  }

  Duration? _parseDuration(String? s) {
    if (s == null) return null;
    final parts = s.split(':');
    if (parts.length != 3) return null;
    return Duration(
      hours: int.tryParse(parts[0]) ?? 0,
      minutes: int.tryParse(parts[1]) ?? 0,
      seconds: int.tryParse(parts[2]) ?? 0,
    );
  }

  String _formatDuration(Duration d) {
    if (d.isNegative) d = Duration.zero;
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h : $m : $s';
  }

  Future<void> _onTaskCompleted() async {
    if (!mounted) return;
    // Le backend a crédité le score : on recharge le profil pour
    // mettre à jour la ScoreBar.
    try {
      await UserSession().loadProfile();
    } catch (_) {}
    if (!mounted) return;
    await _loadData();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Mission complétée !'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _loadData({bool silent = false}) async {
    if (!mounted) return;
    if (!silent) setState(() => _loading = true);
    try {
      final results = await Future.wait([
        ApiService.getTasks(),
        ApiService.getActiveTasks(),
      ]);
      if (!mounted) return;
      setState(() {
        _tasks = results[0];
        _activeTasks = results[1];
        _loading = false;
      });

      if (_activeTasks.isNotEmpty) {
        // Ne réinitialise pas le _deadline si on a déjà un timer local
        // (sinon le compteur ferait un saut visible à chaque refresh)
        if (_deadline == null) {
          final remaining = _parseDuration(_activeTasks.first['timeRemaining']);
          _deadline = remaining != null ? DateTime.now().add(remaining) : null;
        }
        await TaskTracker.start(_activeTasks.first);
      } else {
        _deadline = null;
        await TaskTracker.stop();
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      if (!silent) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Color _difficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Easy':
        return const Color(0xFF4CAF50);
      case 'Medium':
        return const Color(0xFF00BCD4);
      case 'Hard':
        return const Color(0xFFE53935);
      case 'Infernal':
        return const Color(0xFF7B1FA2);
      default:
        return Colors.grey;
    }
  }

  Map<String, dynamic>? _getActiveInfo(String taskId) {
    for (var active in _activeTasks) {
      if (active['taskId'] == taskId) return active;
    }
    return null;
  }

  Future<void> _acceptTask(String taskId) async {
    try {
      await ApiService.acceptTask(taskId);
      await _loadData();
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _cancelTask(String taskId) async {
    try {
      await ApiService.cancelTask(taskId);
      await _loadData();
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = UserSession();
    final hasActiveTask = _activeTasks.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.indigo,
      body: SafeArea(
        child: Column(
          children: [
            ScoreBar(
              score: session.score,
              streak: session.streak,
              avatarUrl: session.avatarUrl,
            ),
            Expanded(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Column(
                          children: [
                            const Text(
                              'Finish tasks to increase your score',
                              style: TextStyle(color: Colors.white60, fontSize: 13),
                              textAlign: TextAlign.center,
                            ),
                            const Text(
                              'Please chose a task',
                              style: TextStyle(
                                color: AppColors.pinkAccent,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: _loading
                            ? const Center(
                                child: CircularProgressIndicator(color: AppColors.pinkAccent),
                              )
                            : ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: _tasks.length > 3 ? 3 : _tasks.length,
                                itemBuilder: (context, index) {
                                  return _buildTaskCard(_tasks[index]);
                                },
                              ),
                      ),
                      if (_tasks.isNotEmpty && _tasks.first['resetPeriodDays'] != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            'Reset in : ${_tasks.first['resetPeriodDays']}d',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (hasActiveTask) ...[
                    Positioned.fill(
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(color: Colors.black.withOpacity(0.65)),
                      ),
                    ),
                    Center(child: _buildActiveTaskOverlay(_activeTasks.first)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentRoute: '/tasks'),
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task) {
    final bool isLocked = task['locked'] ?? false;
    final bool isInProgress = task['inProgress'] ?? false;
    final activeInfo = _getActiveInfo(task['taskId']);
    final String difficulty = task['difficulty'] ?? 'Easy';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLocked
            ? AppColors.indigoDark.withOpacity(0.5)
            : AppColors.indigoDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  task['name'] ?? '',
                  style: TextStyle(
                    color: isLocked ? Colors.white38 : Colors.white70,
                    fontSize: 18,
                  ),
                ),
              ),
              Text(
                difficulty,
                style: TextStyle(
                  color: _difficultyColor(difficulty),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            task['description'] ?? '',
            style: TextStyle(
              color: isLocked ? Colors.white24 : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          if (isLocked)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Text(
                'Please configure your home position to unlock this task',
                style: TextStyle(
                  color: AppColors.pinkAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    'Reward :',
                    style: TextStyle(
                      color: AppColors.pinkAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (task['rewards'] != null && (task['rewards'] as List).isNotEmpty)
                    ...((task['rewards'] as List).take(3).map((r) => Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: _buildRewardImage(r['imageName']),
                        ))),
                ],
              ),
              ElevatedButton(
                onPressed: isLocked
                    ? null
                    : () {
                        if (isInProgress) {
                          _showActiveTaskPopup(context, task, activeInfo);
                        } else {
                          _showTaskPopup(context, task);
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isInProgress
                      ? AppColors.pinkAccent.withOpacity(0.6)
                      : isLocked
                          ? AppColors.pinkAccent.withOpacity(0.4)
                          : AppColors.pinkAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: Text(
                  isInProgress ? 'In progress' : 'Accept task',
                  style: const TextStyle(
                    color: AppColors.indigo,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActiveTaskOverlay(Map<String, dynamic> activeInfo) {
    final String taskId = activeInfo['taskId'];
    final int objective = activeInfo['objective'] ?? 1;

    // Progression live (depuis le tracker), fallback sur la valeur API
    final int liveProgress =
        TaskTracker.currentProgress(taskId) ?? (activeInfo['progress'] ?? 0);
    final int progress =
        liveProgress > objective ? objective : liveProgress;
    final double progressRatio = objective > 0 ? progress / objective : 0;
    final int percent = (progressRatio * 100).toInt();

    // Timer live (calculé depuis _deadline)
    final String? timeRemaining = _deadline != null
        ? _formatDuration(_deadline!.difference(DateTime.now()))
        : activeInfo['timeRemaining'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Material(
        color: AppColors.indigoDark,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                activeInfo['name'] ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                activeInfo['description'] ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  '$progress/$objective',
                  style: const TextStyle(
                    color: AppColors.pinkAccent,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Stack(
                children: [
                  Container(
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: progressRatio.clamp(0.0, 1.0),
                    child: Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 8,
                    top: 2,
                    child: Text(
                      '$percent%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              if (timeRemaining != null) ...[
                const SizedBox(height: 8),
                Center(
                  child: Column(
                    children: [
                      const Text(
                        'Remaining time :',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        timeRemaining,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.white70, size: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Garde l'application ouverte pour que le suivi continue.",
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _showCancelConfirm(context, taskId),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.pinkAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Cancel task',
                    style: TextStyle(
                      color: AppColors.indigo,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRewardImage(String? imageName, {double size = 36}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.pinkAccent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: imageName != null
            ? Image.asset(
                'assets/badges/$imageName',
                fit: BoxFit.cover,
                filterQuality: FilterQuality.none,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.image, color: Colors.white, size: 20),
              )
            : const Icon(Icons.image, color: Colors.white, size: 20),
      ),
    );
  }

  void _showTaskPopup(BuildContext context, Map<String, dynamic> task) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (_) => Dialog(
        backgroundColor: AppColors.indigoDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task['name'] ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                task['description'] ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Reward :',
                style: TextStyle(
                  color: AppColors.pinkAccent,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (task['rewards'] != null)
                ...(task['rewards'] as List).take(3).map((r) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        '${r['badgeName']} (${r['dropRate']}%)',
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    )),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _acceptTask(task['taskId']);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.pinkAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Accept task',
                    style: TextStyle(
                      color: AppColors.indigo,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showActiveTaskPopup(BuildContext context, Map<String, dynamic> task, Map<String, dynamic>? activeInfo) {
    final int progress = activeInfo?['progress'] ?? 0;
    final int objective = activeInfo?['objective'] ?? task['objective'] ?? 1;
    final double progressRatio = objective > 0 ? progress / objective : 0;
    final int percent = (progressRatio * 100).toInt();
    final String? timeRemaining = activeInfo?['timeRemaining'];

    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (_) => Dialog(
        backgroundColor: AppColors.indigoDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task['name'] ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                task['description'] ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  '$progress/$objective',
                  style: const TextStyle(
                    color: AppColors.pinkAccent,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Stack(
                children: [
                  Container(
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: progressRatio.clamp(0.0, 1.0),
                    child: Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 8,
                    top: 2,
                    child: Text(
                      '$percent%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              if (timeRemaining != null) ...[
                const SizedBox(height: 8),
                Center(
                  child: Column(
                    children: [
                      const Text(
                        'Remaining time :',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        timeRemaining,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showCancelConfirm(context, task['taskId']);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.pinkAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Cancel task',
                    style: TextStyle(
                      color: AppColors.indigo,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCancelConfirm(BuildContext context, String taskId) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (_) => Dialog(
        backgroundColor: AppColors.indigoDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Cancel the task ?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'If you really want to cancel the task click on Confirm',
                style: TextStyle(color: Colors.white70, fontSize: 15),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _cancelTask(taskId);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.pinkAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text(
                      'Confirm',
                      style: TextStyle(
                        color: AppColors.indigo,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.pinkAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: AppColors.indigo,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
