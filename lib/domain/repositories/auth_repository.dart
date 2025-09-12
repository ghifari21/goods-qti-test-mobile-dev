import 'package:dartz/dartz.dart';
import 'package:goods/domain/models/user_detail_model.dart';
import 'package:goods/domain/models/user_model.dart';
import 'package:goods/utils/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserModel>> login(String email, String password);

  Future<Either<Failure, UserDetailModel>> getUserDetails();

  Future<Either<Failure, String>> generateToken();

  Future<Either<Failure, UserModel>> logout();
}
