import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goods/helper/go_router_helper.dart';
import 'package:goods/ui/theme/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startSplashScreen();
    });
  }

  void _startSplashScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.goNamed(AppRoute.home.name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Scaffold(
          backgroundColor: constraints.maxWidth < 600 ? primary300 : grey200,
          body: Center(
            child: Image.asset(
              'assets/images/logo_vertical_black.png',
              width: constraints.maxWidth < 600 ? 200 : 400,
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }
}
