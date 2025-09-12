part of 'login_screen_bloc.dart';

abstract class LoginScreenState extends Equatable {
  const LoginScreenState();

  @override
  List<Object> get props => [];
}

class LoginScreenInitial extends LoginScreenState {}

class LoginScreenLoading extends LoginScreenState {}

class LoginScreenError extends LoginScreenState {
  final String message;

  const LoginScreenError(this.message);

  @override
  List<Object> get props => [message];
}

class LoginScreenSuccess extends LoginScreenState {
  final UserModel user;

  const LoginScreenSuccess(this.user);

  @override
  List<Object> get props => [user];
}
