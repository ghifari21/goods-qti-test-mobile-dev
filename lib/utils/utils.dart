import 'package:flutter/material.dart';
import 'package:goods/ui/theme/colors.dart';
import 'package:goods/ui/theme/text_styles.dart';
import 'package:goods/ui/widgets/primary_button_widget.dart';
import 'package:goods/ui/widgets/secondary_button_widget.dart';

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(this);
  }
}

void showSuccessSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), backgroundColor: Colors.green),
  );
}

void showErrorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Theme.of(context).colorScheme.error,
    ),
  );
}

Future<void> showNormalDialog({
  required BuildContext context,
  required String title,
  required String message,
  required String primaryButtonText,
  required VoidCallback onPrimaryButtonPressed,
  required String secondaryButtonText,
  VoidCallback? onSecondaryButtonPressed = null,
}) {
  return showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: grey100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        title: Text(
          title,
          style: titleSmall.copyWith(color: grey800),
          textAlign: TextAlign.center,
        ),
        content: Text(
          message,
          style: bodyMedium.copyWith(color: grey800),
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          SecondaryButton(
            // if onSecondaryButtonPressed is null, close the dialog as default
            onPressed: onSecondaryButtonPressed == null
                ? () {
                    Navigator.of(dialogContext).pop();
                  }
                : onSecondaryButtonPressed,
            child: Text(secondaryButtonText),
          ),
          PrimaryButton(
            onPressed: () {
              onPrimaryButtonPressed();
              Navigator.of(dialogContext).pop();
            },
            child: Text(primaryButtonText),
          ),
        ],
      );
    },
  );
}

Future<void> showSuccessDialog({
  required BuildContext context,
  required String title,
  required String message,
}) {
  return showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: grey100,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        title: Column(
          children: [
            Image.asset(
              'assets/images/dialog_logo.png',
              fit: BoxFit.cover,
              height: 65,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: titleSmall.copyWith(color: grey800),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: Text(
          message,
          style: bodyMedium.copyWith(color: grey800),
          textAlign: TextAlign.center,
        ),
        alignment: Alignment.center,
      );
    },
  );
}
