import 'package:flutter/material.dart';
import 'package:goods/ui/theme/text_styles.dart';
import 'package:goods/ui/widgets/primary_button_widget.dart';

class ErrorScreen extends StatelessWidget {
  final VoidCallback onRetry;
  final String message;

  const ErrorScreen({
    super.key,
    required this.onRetry,
    this.message = 'Something went wrong',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(message, style: bodyLarge, textAlign: TextAlign.center),
              SizedBox(height: 20),
              PrimaryButton(onPressed: onRetry, child: Text('Retry')),
            ],
          ),
        ),
      ),
    );
  }
}
