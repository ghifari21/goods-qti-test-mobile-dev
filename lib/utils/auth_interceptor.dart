import 'package:dio/dio.dart';
import 'package:goods/data/services/shared_preferences_service.dart';

class AuthInterceptor extends Interceptor {
  final SharedPreferencesService _prefs;

  AuthInterceptor(this._prefs);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // get user token from shared preferences
    // if user not logged in, token will be empty string or ''
    final token = _prefs.getUserToken();

    // add auth if user already logged in
    if (token != '' || token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // continue request
    super.onRequest(options, handler);
  }
}
