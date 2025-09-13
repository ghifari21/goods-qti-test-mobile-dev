part of 'splash_screen_bloc.dart';

abstract class SplashScreenState extends Equatable {
  const SplashScreenState();

  @override
  List<Object> get props => [];
}

class SplashInitial extends SplashScreenState {}

class SplashLoading extends SplashScreenState {}

class Authenticated extends SplashScreenState {}

class Unauthenticated extends SplashScreenState {}

class SplashError extends SplashScreenState {
  final String message;

  const SplashError(this.message);

  @override
  List<Object> get props => [message];
}
