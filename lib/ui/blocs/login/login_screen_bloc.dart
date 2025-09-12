import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:goods/domain/models/user_model.dart';
import 'package:goods/domain/usecases/login_use_case.dart';

part 'login_screen_event.dart';
part 'login_screen_state.dart';

class LoginScreenBloc extends Bloc<LoginScreenEvent, LoginScreenState> {
  final LoginUseCase useCase;

  LoginScreenBloc({required this.useCase}) : super(LoginScreenInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginScreenLoading());

      final result = await useCase.execute(event.email, event.password);
      result.fold(
        (failure) => emit(LoginScreenError(failure.message)),
        (user) => emit(LoginScreenSuccess(user)),
      );
    });
  }
}
