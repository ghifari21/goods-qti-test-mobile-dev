import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:goods/data/repositories/asset_repository_impl.dart';
import 'package:goods/data/repositories/auth_repository_impl.dart';
import 'package:goods/data/repositories/home_repository_impl.dart';
import 'package:goods/data/services/api_service.dart';
import 'package:goods/data/services/shared_preferences_service.dart';
import 'package:goods/domain/repositories/asset_repository.dart';
import 'package:goods/domain/repositories/auth_repository.dart';
import 'package:goods/domain/repositories/home_repository.dart';
import 'package:goods/utils/auth_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  // shared prefs instance
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);
  getIt.registerLazySingleton<SharedPreferencesService>(
    () => SharedPreferencesService(getIt<SharedPreferences>()),
  );

  // dio instance
  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://be-ksp.analitiq.id/',
        connectTimeout: Duration(seconds: 30),
        receiveTimeout: Duration(seconds: 30),
        contentType: Headers.jsonContentType,
      ),
    );

    dio.interceptors.add(AuthInterceptor(getIt<SharedPreferencesService>()));

    return dio;
  });

  getIt.registerLazySingleton<ApiService>(() => ApiService(getIt<Dio>()));

  // repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      api: getIt<ApiService>(),
      prefs: getIt<SharedPreferencesService>(),
    ),
  );

  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(api: getIt<ApiService>()),
  );

  getIt.registerLazySingleton<AssetRepository>(
    () => AssetRepositoryImpl(api: getIt<ApiService>()),
  );
}
