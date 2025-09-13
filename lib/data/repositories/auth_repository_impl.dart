import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:goods/data/services/api_service.dart';
import 'package:goods/data/services/shared_preferences_service.dart';
import 'package:goods/domain/models/user_detail_model.dart';
import 'package:goods/domain/models/user_model.dart';
import 'package:goods/domain/repositories/auth_repository.dart';
import 'package:goods/utils/failure.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiService _api;
  final SharedPreferencesService _prefs;

  AuthRepositoryImpl({
    required ApiService api,
    required SharedPreferencesService prefs,
  }) : _prefs = prefs,
       _api = api;

  @override
  Future<Either<Failure, UserModel>> login(
    String email,
    String password,
  ) async {
    try {
      final result = await _api.login(email, password);
      final user = result.toModel();
      await _prefs.saveUser(
        token: user.token,
        username: user.username,
        email: user.email,
        password: password,
      );

      return Right(user);
    } on SocketException catch (e) {
      return Left(ConnectionFailure(e.toString()));
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        return Left(ServerFailure('Invalid email or password'));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserDetailModel>> getUserDetails() async {
    try {
      final result = await _api.getUserDetails();
      final userDetails = result.toModel();
      await _prefs.saveRefreshToken(userDetails.refreshedToken);
      return Right(userDetails);
    } on SocketException catch (e) {
      return Left(ConnectionFailure(e.toString()));
    } on DioException catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> generateToken() async {
    try {
      final username = _prefs.getUsername();
      final password = _prefs.getPassword();
      final refreshToken = _prefs.getRefreshToken();

      final result = await _api.generateToken(username, password, refreshToken);
      await _prefs.saveUserToken(result);
      return Right('Token generated successfully');
    } on SocketException catch (e) {
      return Left(ConnectionFailure(e.toString()));
    } on DioException catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> logout() async {
    try {
      final result = await _api.logout();
      await _prefs.clearAll();
      return Right(result.toModel());
    } on SocketException catch (e) {
      return Left(ConnectionFailure(e.toString()));
    } on DioException catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
