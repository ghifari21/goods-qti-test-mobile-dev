import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goods/helper/go_router_helper.dart';
import 'package:goods/ui/theme/text_styles.dart';
import 'package:goods/ui/widgets/primary_button_widget.dart';
import 'package:lottie/lottie.dart';

class UnknownScreen extends StatelessWidget {
  const UnknownScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lottie/lottieError.json',
              width: 200,
              height: 200,
              fit: BoxFit.fill,
            ),
            Text('Unknown URL', style: titleLarge, textAlign: TextAlign.center),
            Text(
              'The URL you entered is unknown. Please check again.',
              style: bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox.square(dimension: 16.0),

            PrimaryButton(
              child: const Text('Back to Home'),
              onPressed: () => context.goNamed(AppRoute.home.name),
            ),
          ],
        ),
      ),
    );
  }
}
