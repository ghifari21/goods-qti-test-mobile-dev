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
import 'package:goods/domain/usecases/create_asset_use_case.dart';
import 'package:goods/domain/usecases/delete_asset_use_case.dart';
import 'package:goods/domain/usecases/generate_token_use_case.dart';
import 'package:goods/domain/usecases/get_agg_asset_by_location_use_case.dart';
import 'package:goods/domain/usecases/get_agg_asset_by_status_use_case.dart';
import 'package:goods/domain/usecases/get_all_assets_use_case.dart';
import 'package:goods/domain/usecases/get_all_locations_use_case.dart';
import 'package:goods/domain/usecases/get_all_statuses_use_case.dart';
import 'package:goods/domain/usecases/get_detail_asset_use_case.dart';
import 'package:goods/domain/usecases/get_user_details_use_case.dart';
import 'package:goods/domain/usecases/login_use_case.dart';
import 'package:goods/domain/usecases/logout_use_case.dart';
import 'package:goods/domain/usecases/search_assets_use_case.dart';
import 'package:goods/domain/usecases/update_asset_use_case.dart';
import 'package:goods/helper/go_router_helper.dart';
import 'package:goods/ui/blocs/asset/asset_screen_bloc.dart';
import 'package:goods/ui/blocs/edit/edit_asset_screen_bloc.dart';
import 'package:goods/ui/blocs/home/home_screen_bloc.dart';
import 'package:goods/ui/blocs/input/input_asset_screen_bloc.dart';
import 'package:goods/ui/blocs/login/login_screen_bloc.dart';
import 'package:goods/ui/blocs/splash/splash_screen_bloc.dart';
import 'package:goods/utils/auth_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setupLocator() async {
  // go router
  getIt.registerLazySingleton<GoRouterHelper>(() => GoRouterHelper());

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
        validateStatus: (_) => true,
      ),
    );

    dio.interceptors.add(
      AuthInterceptor(getIt<SharedPreferencesService>(), dio),
    );

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

  // use cases
  getIt.registerLazySingleton(() => CreateAssetUseCase(getIt()));
  getIt.registerLazySingleton(() => DeleteAssetUseCase(getIt()));
  getIt.registerLazySingleton(() => GenerateTokenUseCase(getIt()));
  getIt.registerLazySingleton(() => GetAggAssetByLocationUseCase(getIt()));
  getIt.registerLazySingleton(() => GetAggAssetByStatusUseCase(getIt()));
  getIt.registerLazySingleton(() => GetAllAssetsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetAllLocationsUseCase(getIt()));
  getIt.registerLazySingleton(() => GetAllStatusesUseCase(getIt()));
  getIt.registerLazySingleton(() => GetDetailAssetUseCase(getIt()));
  getIt.registerLazySingleton(() => GetUserDetailsUseCase(getIt()));
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt()));
  getIt.registerLazySingleton(() => SearchAssetsUseCase(getIt()));
  getIt.registerLazySingleton(() => UpdateAssetUseCase(getIt()));

  // blocs
  getIt.registerFactory(() => LoginScreenBloc(useCase: getIt()));
  getIt.registerFactory(
    () => HomeScreenBloc(
      getAggAssetByLocationUseCase: getIt(),
      getAggAssetByStatusUseCase: getIt(),
      getUserDetailsUseCase: getIt(),
      logoutUseCase: getIt(),
    ),
  );
  getIt.registerFactory(
    () => AssetScreenBloc(
      getAllAssetsUseCase: getIt(),
      searchAssetsUseCase: getIt(),
    ),
  );
  getIt.registerFactory(
    () => SplashScreenBloc(prefs: getIt(), generateToken: getIt()),
  );
  getIt.registerFactory(
    () => InputAssetScreenBloc(
      getAllLocationsUseCase: getIt(),
      getAllStatusesUseCase: getIt(),
      createAssetUseCase: getIt(),
    ),
  );
  getIt.registerFactory(
    () => EditAssetScreenBloc(
      getDetailAssetUseCase: getIt(),
      getAllLocationsUseCase: getIt(),
      getAllStatusesUseCase: getIt(),
      updateAssetUseCase: getIt(),
      deleteAssetUseCase: getIt(),
    ),
  );
}
