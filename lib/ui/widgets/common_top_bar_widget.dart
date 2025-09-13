import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goods/ui/blocs/home/home_screen_bloc.dart';
import 'package:goods/ui/theme/colors.dart';
import 'package:goods/ui/theme/text_styles.dart';
import 'package:goods/ui/widgets/primary_button_widget.dart';
import 'package:goods/utils/utils.dart';

class CommonTopBar extends StatelessWidget {
  final String username;
  final String email;

  const CommonTopBar({super.key, required this.username, required this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.5),
      color: grey100,
      width: double.infinity,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/images/logo_horizontal_black.png',
                height: 32,
                fit: BoxFit.cover,
              ),
              Text('TEST QTI', style: labelLarge.copyWith(color: grey800)),
            ],
          ),
          const SizedBox(height: 23),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('assets/images/avatar.png'),
                    radius: 24,
                  ),
                  const SizedBox(width: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: labelLarge.copyWith(color: grey800),
                      ),
                      Text(email, style: labelMedium.copyWith(color: grey700)),
                    ],
                  ),
                ],
              ),
              PrimaryButton(
                onPressed: () {
                  showNormalDialog(
                    context: context,
                    title: 'Logout',
                    message:
                        'When you want to use this app,\nyou have to relogin, are you sure?',
                    primaryButtonText: 'Logout',
                    onPrimaryButtonPressed: () {
                      context.read<HomeScreenBloc>().add(LogoutEvent());
                    },
                    secondaryButtonText: 'Cancel',
                    onSecondaryButtonPressed: null,
                  );
                },
                child: Text('Logout', style: buttonSmall),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
