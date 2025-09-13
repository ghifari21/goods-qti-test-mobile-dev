import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:goods/data/services/shared_preferences_service.dart';
import 'package:goods/di/injection.dart';
import 'package:goods/ui/screens/home_screen.dart';
import 'package:goods/ui/screens/login_screen.dart';
import 'package:goods/ui/screens/splash_screen.dart';
import 'package:goods/ui/screens/unknown_screen.dart';

enum AppRoute { splash, login, home, inputAsset, editAsset }

class GoRouterHelper {
  static final GlobalKey<NavigatorState> parentNavigatorKey =
      GlobalKey<NavigatorState>();

  GoRouter get goRouter => _goRouter;

  final _goRouter = GoRouter(
    navigatorKey: parentNavigatorKey,
    initialLocation: '/splash',
    errorBuilder: (context, state) => const UnknownScreen(),
    redirect: (BuildContext context, GoRouterState state) async {
      final prefs = getIt<SharedPreferencesService>();
      final bool isLoggedIn = prefs.getUserToken().isNotEmpty;
      final bool hasRefreshToken = prefs.getRefreshToken().isNotEmpty;

      final String location = state.matchedLocation;
      final bool isAuthRoute = location == '/login';
      final bool isSplashRoute = location == '/splash';

      if (!isLoggedIn && !isSplashRoute) {
        if (hasRefreshToken) {
          return '/splash';
        }
        return isAuthRoute ? null : '/login';
      }

      if (isLoggedIn && isAuthRoute) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        name: AppRoute.splash.name,
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: AppRoute.login.name,
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        name: AppRoute.home.name,
        builder: (context, state) => HomeScreen(),
        routes: [],
      ),
    ],
  );
}
