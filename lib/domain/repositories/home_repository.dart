import 'package:dartz/dartz.dart';
import 'package:goods/domain/models/agg_asset_by_location_model.dart';
import 'package:goods/domain/models/agg_asset_by_status_model.dart';
import 'package:goods/domain/models/general_model.dart';
import 'package:goods/utils/failure.dart';

abstract class HomeRepository {
  Future<Either<Failure, AggAssetByStatusModel>> getAggAssetByStatus();

  Future<Either<Failure, AggAssetByLocationModel>> getAggAssetByLocation();

  Future<Either<Failure, GeneralModel>> getAllLocations();

  Future<Either<Failure, GeneralModel>> getAllStatuses();
}
