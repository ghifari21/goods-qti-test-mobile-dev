import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:goods/data/services/api_service.dart';
import 'package:goods/domain/models/agg_asset_by_location_model.dart';
import 'package:goods/domain/models/agg_asset_by_status_model.dart';
import 'package:goods/domain/models/general_model.dart';
import 'package:goods/domain/repositories/home_repository.dart';
import 'package:goods/utils/failure.dart';

class HomeRepositoryImpl implements HomeRepository {
  final ApiService _api;

  HomeRepositoryImpl({required ApiService api}) : _api = api;

  @override
  Future<Either<Failure, AggAssetByLocationModel>>
  getAggAssetByLocation() async {
    try {
      final result = await _api.getAggAssetByLocation();
      final aggAssetByLocation = result.toModel();
      return Right(aggAssetByLocation);
    } on SocketException catch (e) {
      return Left(ConnectionFailure(e.toString()));
    } on DioException catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AggAssetByStatusModel>> getAggAssetByStatus() async {
    try {
      final result = await _api.getAggAssetByStatus();
      final aggAssetByStatus = result.toModel();
      return Right(aggAssetByStatus);
    } on SocketException catch (e) {
      return Left(ConnectionFailure(e.toString()));
    } on DioException catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, GeneralModel>> getAllLocations() async {
    try {
      final result = await _api.getAllLocations();
      final locations = result.toModel();
      return Right(locations);
    } on SocketException catch (e) {
      return Left(ConnectionFailure(e.toString()));
    } on DioException catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, GeneralModel>> getAllStatuses() async {
    try {
      final result = await _api.getAllStatuses();
      final statuses = result.toModel();
      return Right(statuses);
    } on SocketException catch (e) {
      return Left(ConnectionFailure(e.toString()));
    } on DioException catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
