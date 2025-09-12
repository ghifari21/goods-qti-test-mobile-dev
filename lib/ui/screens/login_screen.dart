import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:goods/helper/go_router_helper.dart';
import 'package:goods/ui/blocs/login/login_screen_bloc.dart';
import 'package:goods/ui/theme/colors.dart';
import 'package:goods/ui/theme/text_styles.dart';
import 'package:goods/ui/widgets/general_text_form_field_widget.dart';
import 'package:goods/ui/widgets/primary_button_widget.dart';
import 'package:goods/utils/utils.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return const LoginScreenMobile();
        } else {
          return const LoginScreenWeb();
        }
      },
    );
  }
}

class LoginScreenMobile extends StatefulWidget {
  const LoginScreenMobile({super.key});

  @override
  State<LoginScreenMobile> createState() => _LoginScreenMobileState();
}

class _LoginScreenMobileState extends State<LoginScreenMobile> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: grey200,
        body: BlocListener<LoginScreenBloc, LoginScreenState>(
          listener: (context, state) {
            // Navigate to home screen if login is successful
            // Show error message if login fails
            if (state is LoginScreenSuccess) {
              context.goNamed(AppRoute.home.name);
            } else if (state is LoginScreenError) {
              showErrorSnackBar(context, state.message);
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                  Image.asset(
                    'assets/images/logo_banner_top.png',
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 36.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          height: 33,
                          fit: BoxFit.cover,
                        ),
                        Text(
                          'Welcome back!',
                          style: headlineLarge2.copyWith(color: grey100),
                        ),
                        Text(
                          'You’ve been missed,\nPlease sign in your account',
                          style: bodyVeryLarge.copyWith(color: grey100),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 42.0),

              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GeneralTextFormField(
                        controller: _emailController,
                        hintText: 'Email',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This form is required';
                          }
                          if (!value.isValidEmail()) {
                            return 'Invalid email!';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 18),
                      GeneralTextFormField(
                        controller: _passwordController,
                        hintText: 'Password',
                        prefixIcon: Icons.lock_outline,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This form is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 70),
                      // if loading show circular progress indicator
                      // else show button
                      BlocBuilder<LoginScreenBloc, LoginScreenState>(
                        builder: (context, state) {
                          if (state is LoginScreenLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return PrimaryButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<LoginScreenBloc>().add(
                                    LoginButtonPressed(
                                      email: _emailController.text.trim(),
                                      password: _passwordController.text.trim(),
                                    ),
                                  );
                                }
                              },
                              width: double.infinity,
                              child: const Text('Login'),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginScreenWeb extends StatefulWidget {
  const LoginScreenWeb({super.key});

  @override
  State<LoginScreenWeb> createState() => _LoginScreenWebState();
}

class _LoginScreenWebState extends State<LoginScreenWeb> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
