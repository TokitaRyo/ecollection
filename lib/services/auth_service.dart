import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'config.dart';

class AuthService {
  static const String _tokenKey = 'idToken';
  static const String _refreshKey = 'refreshToken';
  static const String _uidKey = 'uid';

  static String? _idToken;
  static String? _refreshToken;
  static String? _uid;

  static String? get currentUid => _uid;
  static bool get isLoggedIn => _idToken != null;

  /// Charge les tokens depuis le stockage persistant. À appeler au démarrage.
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _idToken = prefs.getString(_tokenKey);
    _refreshToken = prefs.getString(_refreshKey);
    _uid = prefs.getString(_uidKey);
  }

  static Future<String?> getIdToken() async => _idToken;

  static Future<void> _saveTokens({
    required String idToken,
    required String refreshToken,
    required String uid,
  }) async {
    _idToken = idToken;
    _refreshToken = refreshToken;
    _uid = uid;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, idToken);
    await prefs.setString(_refreshKey, refreshToken);
    await prefs.setString(_uidKey, uid);
  }

  static Future<void> signIn({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('${AppConfig.apiBaseUrl}/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode != 200) {
      String detail = 'Authentification échouée';
      try {
        detail = jsonDecode(response.body)['detail'] ?? detail;
      } catch (_) {}
      throw AuthException(detail);
    }
    final data = jsonDecode(response.body);
    await _saveTokens(
      idToken: data['idToken'],
      refreshToken: data['refreshToken'],
      uid: data['uid'],
    );
  }

  /// Tente de rafraîchir le ID token via le refresh token. Retourne true en cas de succès.
  static Future<bool> tryRefresh() async {
    if (_refreshToken == null) return false;
    try {
      final response = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/auth/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': _refreshToken}),
      );
      if (response.statusCode != 200) return false;
      final data = jsonDecode(response.body);
      await _saveTokens(
        idToken: data['idToken'],
        refreshToken: data['refreshToken'],
        uid: data['uid'],
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<void> signOut() async {
    _idToken = null;
    _refreshToken = null;
    _uid = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_refreshKey);
    await prefs.remove(_uidKey);
  }
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}
