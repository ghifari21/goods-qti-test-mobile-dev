import 'package:dartz/dartz.dart';
import 'package:goods/domain/models/user_model.dart';
import 'package:goods/domain/repositories/auth_repository.dart';
import 'package:goods/utils/failure.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<Either<Failure, UserModel>> execute(String email, String password) {
    return _repository.login(email, password);
  }
}
