import 'package:dartz/dartz.dart';
import 'package:goods/domain/models/asset_detail_model.dart';
import 'package:goods/domain/models/asset_general_model.dart';
import 'package:goods/domain/models/asset_model.dart';
import 'package:goods/utils/failure.dart';

abstract class AssetRepository {
  Future<Either<Failure, AssetModel>> getAllAssets(int page, int size);

  Future<Either<Failure, AssetModel>> searchAssets(
    int page,
    int size,
    String query,
  );

  Future<Either<Failure, AssetDetailModel>> getDetailAsset(String id);

  Future<Either<Failure, AssetGeneralModel>> createAsset(
    String name,
    String statusId,
    String locationId,
  );

  Future<Either<Failure, AssetGeneralModel>> updateAsset(
    String id,
    String name,
    String statusId,
    String locationId,
  );

  Future<Either<Failure, String>> deleteAsset(String id);
}
