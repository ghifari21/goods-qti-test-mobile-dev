import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences _prefs;

  SharedPreferencesService(this._prefs);

  static const _keySessionToken = 'session_token';
  static const _keyRefreshToken = 'refresh_token';
  static const _keyUsername = 'username';
  static const _keyUserEmail = 'user_email';
  static const _keyPassword = 'password';

  Future<void> saveUserToken(String token) async {
    try {
      await _prefs.setString(_keySessionToken, token);
    } catch (e) {
      throw Exception('Shared preferences cannot save the user token');
    }
  }

  String getUserToken() {
    return _prefs.getString(_keySessionToken) ?? '';
  }

  Future<void> saveRefreshToken(String token) async {
    try {
      await _prefs.setString(_keyRefreshToken, token);
    } catch (e) {
      throw Exception('Shared preferences cannot save the refresh token');
    }
  }

  String getRefreshToken() {
    return _prefs.getString(_keyRefreshToken) ?? '';
  }

  Future<void> saveUsername(String username) async {
    try {
      await _prefs.setString(_keyUsername, username);
    } catch (e) {
      throw Exception('Shared preferences cannot save the username');
    }
  }

  String getUsername() {
    return _prefs.getString(_keyUsername) ?? '';
  }

  Future<void> saveUserEmail(String email) async {
    try {
      await _prefs.setString(_keyUserEmail, email);
    } catch (e) {
      throw Exception('Shared preferences cannot save the user email');
    }
  }

  String getUserEmail() {
    return _prefs.getString(_keyUserEmail) ?? '';
  }

  Future<void> savePassword(String password) async {
    try {
      await _prefs.setString(_keyPassword, password);
    } catch (e) {
      throw Exception('Shared preferences cannot save the password');
    }
  }

  String getPassword() {
    return _prefs.getString(_keyPassword) ?? '';
  }

  Future<void> saveUser({
    required String token,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      await Future.wait([
        _prefs.setString(_keySessionToken, token),
        _prefs.setString(_keyUsername, username),
        _prefs.setString(_keyUserEmail, email),
        _prefs.setString(_keyPassword, password),
      ]);
    } catch (e) {
      throw Exception('Shared preferences cannot save the user details');
    }
  }

  Future<void> clearAll() async {
    try {
      await _prefs.clear();
    } catch (e) {
      throw Exception('Shared preferences cannot clear all data');
    }
  }
}
