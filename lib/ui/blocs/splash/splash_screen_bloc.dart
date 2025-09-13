import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:goods/data/services/shared_preferences_service.dart';
import 'package:goods/domain/usecases/generate_token_use_case.dart';

part 'splash_screen_event.dart';
part 'splash_screen_state.dart';

class SplashScreenBloc extends Bloc<SplashScreenEvent, SplashScreenState> {
  final SharedPreferencesService _prefs;
  final GenerateTokenUseCase _generateToken;

  SplashScreenBloc({
    required SharedPreferencesService prefs,
    required GenerateTokenUseCase generateToken,
  }) : _prefs = prefs,
       _generateToken = generateToken,
       super(SplashInitial()) {
    on<CheckAuthentication>(_onCheckAuthentication);
  }

  Future<void> _onCheckAuthentication(
    CheckAuthentication event,
    Emitter<SplashScreenState> emit,
  ) async {
    emit(SplashLoading());
    await Future.delayed(const Duration(seconds: 2));

    if (_prefs.getRefreshToken().isNotEmpty) {
      final result = await _generateToken.execute();
      result.fold(
        (failure) => emit(Unauthenticated()),
        (success) => emit(Authenticated()),
      );
    } else {
      emit(Unauthenticated());
    }
  }
}
