import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import 'config.dart';

class ApiService {
  static String get baseUrl => AppConfig.apiBaseUrl;

  static Future<Map<String, String>> _headers() async {
    final token = await AuthService.getIdToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }


  // ========== Auth ==========

  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String nickname,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'nickname': nickname,
      }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw ApiException(response.statusCode, jsonDecode(response.body)['detail'] ?? 'Erreur inconnue');
  }

  // ========== User ==========

  static Future<Map<String, dynamic>> getProfile() async {
    final response = await http.get(
      Uri.parse('$baseUrl/user/profile'),
      headers: await _headers(),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw ApiException(response.statusCode, jsonDecode(response.body)['detail'] ?? 'Erreur');
  }

  static Future<void> updateProfile({String? nickname, String? avatarUrl}) async {
    final body = <String, dynamic>{};
    if (nickname != null) body['nickname'] = nickname;
    if (avatarUrl != null) body['avatarUrl'] = avatarUrl;

    final response = await http.put(
      Uri.parse('$baseUrl/user/profile'),
      headers: await _headers(),
      body: jsonEncode(body),
    );
    if (response.statusCode != 200) {
      throw ApiException(response.statusCode, jsonDecode(response.body)['detail'] ?? 'Erreur');
    }
  }

  static Future<void> updateHomePosition({
    required double latitude,
    required double longitude,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/user/home-position'),
      headers: await _headers(),
      body: jsonEncode({
        'homeLatitude': latitude,
        'homeLongitude': longitude,
      }),
    );
    if (response.statusCode != 200) {
      throw ApiException(response.statusCode, jsonDecode(response.body)['detail'] ?? 'Erreur');
    }
  }

  // ========== Leaderboard ==========

  static Future<List<dynamic>> getLeaderboard({int limit = 50}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/leaderboard?limit=$limit'),
      headers: await _headers(),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw ApiException(response.statusCode, 'Erreur leaderboard');
  }

  static Future<Map<String, dynamic>> getMyRank() async {
    final response = await http.get(
      Uri.parse('$baseUrl/leaderboard/me'),
      headers: await _headers(),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw ApiException(response.statusCode, 'Erreur rank');
  }

  // ========== Tasks ==========

  static Future<List<dynamic>> getTasks() async {
    final response = await http.get(
      Uri.parse('$baseUrl/tasks'),
      headers: await _headers(),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw ApiException(response.statusCode, 'Erreur tasks');
  }

  static Future<void> acceptTask(String taskId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tasks/accept'),
      headers: await _headers(),
      body: jsonEncode({'taskId': taskId}),
    );
    if (response.statusCode != 200) {
      throw ApiException(response.statusCode, jsonDecode(response.body)['detail'] ?? 'Erreur');
    }
  }

  static Future<List<dynamic>> getActiveTasks() async {
    final response = await http.get(
      Uri.parse('$baseUrl/tasks/active'),
      headers: await _headers(),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw ApiException(response.statusCode, 'Erreur active tasks');
  }

  static Future<Map<String, dynamic>> updateProgress({
    required String taskId,
    required int progress,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/tasks/progress'),
      headers: await _headers(),
      body: jsonEncode({'taskId': taskId, 'progress': progress}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw ApiException(response.statusCode, 'Erreur progress');
  }

  static Future<void> cancelTask(String taskId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tasks/cancel'),
      headers: await _headers(),
      body: jsonEncode({'taskId': taskId}),
    );
    if (response.statusCode != 200) {
      throw ApiException(response.statusCode, jsonDecode(response.body)['detail'] ?? 'Erreur');
    }
  }

  // ========== Badges ==========

  static Future<List<dynamic>> getMyBadges() async {
    final response = await http.get(
      Uri.parse('$baseUrl/badges'),
      headers: await _headers(),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw ApiException(response.statusCode, 'Erreur badges');
  }

  static Future<Map<String, dynamic>> getBadgeDetail(String badgeId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/badges/$badgeId'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw ApiException(response.statusCode, 'Badge introuvable');
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException(this.statusCode, this.message);

  @override
  String toString() => 'ApiException($statusCode): $message';
}
