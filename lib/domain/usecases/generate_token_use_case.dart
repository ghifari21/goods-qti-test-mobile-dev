import 'package:dartz/dartz.dart';
import 'package:goods/domain/repositories/auth_repository.dart';
import 'package:goods/utils/failure.dart';

class GenerateTokenUseCase {
  final AuthRepository _repository;

  GenerateTokenUseCase(this._repository);

  Future<Either<Failure, String>> execute() {
    return _repository.generateToken();
  }
}
