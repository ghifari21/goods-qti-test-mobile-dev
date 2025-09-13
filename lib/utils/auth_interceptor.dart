import 'package:dio/dio.dart';
import 'package:goods/data/services/shared_preferences_service.dart';
import 'package:goods/di/injection.dart';
import 'package:goods/helper/go_router_helper.dart';

class AuthInterceptor extends Interceptor {
  final SharedPreferencesService _prefs;
  final Dio _dio;

  AuthInterceptor(this._prefs, this._dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // get user token from shared preferences
    // if user not logged in, token will be empty string or ''
    final token = _prefs.getUserToken();

    // add auth if user already logged in
    if (token != '' || token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 &&
        !err.requestOptions.path.contains('auth/login') &&
        !err.requestOptions.path.contains('auth/token/')) {
      try {
        final newAccessToken = await _refreshToken();
        if (newAccessToken != null) {
          // Update the access token in SharedPreferences
          await _prefs.saveUserToken(newAccessToken);
          // Clone the original request with the new token
          final newOptions = Options(
            method: err.requestOptions.method,
            headers: err.requestOptions.headers
              ..['Authorization'] = 'Bearer $newAccessToken',
          );
          final clonedRequest = await _dio.request(
            err.requestOptions.path,
            options: newOptions,
            data: err.requestOptions.data,
            queryParameters: err.requestOptions.queryParameters,
          );
          // Resolve the original request with the new response
          return handler.resolve(clonedRequest);
        } else {
          // If refresh token is null, logout
          await _logout();
          return super.onError(err, handler);
        }
      } catch (e) {
        // If any other error occurs during refresh, logout
        await _logout();
        return super.onError(err, handler);
      }
    }
    super.onError(err, handler);
  }

  Future<String?> _refreshToken() async {
    try {
      final refreshToken = _prefs.getRefreshToken();
      final username = _prefs.getUsername();
      final password = _prefs.getPassword();

      if (refreshToken.isEmpty || username.isEmpty || password.isEmpty) {
        return null;
      }
      // Use a new Dio instance to avoid interceptor loop
      final dio = getIt<Dio>();
      final response = await dio.post(
        'auth/token/',
        data: {'username': username, 'password': password},
        options: Options(
          headers: {
            'Authorization': 'Bearer $refreshToken',
            'Content-Type': Headers.formUrlEncodedContentType,
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data['access_token'];
      }
    } catch (e) {
      // Handle refresh token failure
      await _logout();
      print("Failed to refresh token: $e");
    }
    return null;
  }

  Future<void> _logout() async {
    await _prefs.clearAll();
    // Use GoRouter to navigate to login screen.
    getIt<GoRouterHelper>().goRouter.goNamed(AppRoute.login.name);
    print("Session cleared. Navigating to login.");
  }
}
