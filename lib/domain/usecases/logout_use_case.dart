import 'package:dartz/dartz.dart';
import 'package:goods/domain/models/user_model.dart';
import 'package:goods/domain/repositories/auth_repository.dart';
import 'package:goods/utils/failure.dart';

class LogoutUseCase {
  final AuthRepository _repository;

  LogoutUseCase(this._repository);

  Future<Either<Failure, UserModel>> execute() {
    return _repository.logout();
  }
}
