import 'package:dartz/dartz.dart';
import 'package:goods/domain/models/user_detail_model.dart';
import 'package:goods/domain/repositories/auth_repository.dart';
import 'package:goods/utils/failure.dart';

class GetUserDetailsUseCase {
  final AuthRepository _repository;

  GetUserDetailsUseCase(this._repository);

  Future<Either<Failure, UserDetailModel>> execute() {
    return _repository.getUserDetails();
  }
}
