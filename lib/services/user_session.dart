import 'api_service.dart';

class UserSession {
  static final UserSession _instance = UserSession._internal();
  factory UserSession() => _instance;
  UserSession._internal();

  Map<String, dynamic>? _profile;

  int get score => _profile?['score'] ?? 0;
  int get streak => _profile?['currentStreak'] ?? 0;
  String? get avatarUrl => _profile?['avatarUrl'];
  String get nickname => _profile?['nickname'] ?? '';
  String? get email => _profile?['email'];
  int get totalSteps => _profile?['numberTotalOfSteps'] ?? 0;
  String? get dateCreation => _profile?['dateCreation'];
  bool get hasHome => _profile?['homeLatitude'] != null;
  double? get homeLatitude => _profile?['homeLatitude']?.toDouble();
  double? get homeLongitude => _profile?['homeLongitude']?.toDouble();

  Map<String, dynamic>? get profile => _profile;

  Future<void> loadProfile() async {
    _profile = await ApiService.getProfile();
  }

  void clear() {
    _profile = null;
  }
}
