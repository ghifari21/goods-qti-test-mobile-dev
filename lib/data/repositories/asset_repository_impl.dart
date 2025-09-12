import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:goods/data/services/api_service.dart';
import 'package:goods/domain/models/asset_detail_model.dart';
import 'package:goods/domain/models/asset_general_model.dart';
import 'package:goods/domain/models/asset_model.dart';
import 'package:goods/domain/repositories/asset_repository.dart';
import 'package:goods/utils/failure.dart';

class AssetRepositoryImpl implements AssetRepository {
  final ApiService _api;

  AssetRepositoryImpl({required ApiService api}) : _api = api;

  @override
  Future<Either<Failure, AssetModel>> getAllAssets(int page, int size) async {
    try {
      final result = await _api.getAllAssets(page, size, null);
      final assets = result.toModel();
      return Right(assets);
    } on SocketException catch (e) {
      return Left(ConnectionFailure(e.toString()));
    } on DioException catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AssetModel>> searchAssets(
    int page,
    int size,
    String query,
  ) async {
    try {
      final result = await _api.getAllAssets(page, size, query);
      final assets = result.toModel();
      return Right(assets);
    } on SocketException catch (e) {
      return Left(ConnectionFailure(e.toString()));
    } on DioException catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AssetDetailModel>> getDetailAsset(String id) async {
    try {
      final result = await _api.getDetailAsset(id);
      final assetDetail = result.toModel();
      return Right(assetDetail);
    } on SocketException catch (e) {
      return Left(ConnectionFailure(e.toString()));
    } on DioException catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AssetGeneralModel>> createAsset(
    String name,
    String statusId,
    String locationId,
  ) async {
    try {
      final result = await _api.createAsset(name, statusId, locationId);
      final asset = result.toModel();
      return Right(asset);
    } on SocketException catch (e) {
      return Left(ConnectionFailure(e.toString()));
    } on DioException catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AssetGeneralModel>> updateAsset(
    String id,
    String name,
    String statusId,
    String locationId,
  ) async {
    try {
      final result = await _api.updateAsset(id, name, statusId, locationId);
      final asset = result.toModel();
      return Right(asset);
    } on SocketException catch (e) {
      return Left(ConnectionFailure(e.toString()));
    } on DioException catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> deleteAsset(String id) async {
    try {
      await _api.deleteAsset(id);
      return Right('Asset deleted successfully');
    } on SocketException catch (e) {
      return Left(ConnectionFailure(e.toString()));
    } on DioException catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
