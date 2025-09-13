import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goods/di/injection.dart';
import 'package:goods/helper/go_router_helper.dart';
import 'package:goods/ui/blocs/asset/asset_screen_bloc.dart';
import 'package:goods/ui/blocs/home/home_screen_bloc.dart';
import 'package:goods/ui/blocs/input/input_asset_screen_bloc.dart';
import 'package:goods/ui/blocs/login/login_screen_bloc.dart';
import 'package:goods/ui/blocs/splash/splash_screen_bloc.dart';
import 'package:goods/ui/theme/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupLocator();
  await getIt.allReady();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<LoginScreenBloc>()),
        BlocProvider(create: (context) => getIt<HomeScreenBloc>()),
        BlocProvider(create: (context) => getIt<AssetScreenBloc>()),
        BlocProvider(create: (context) => getIt<SplashScreenBloc>()),
        BlocProvider(create: (context) => getIt<InputAssetScreenBloc>()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Goods',
      themeMode: ThemeMode.light,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primary800),
      ),
      routerConfig: getIt<GoRouterHelper>().goRouter,
    );
  }
}
