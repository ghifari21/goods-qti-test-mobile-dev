import 'package:dartz/dartz.dart';
import 'package:goods/domain/models/agg_asset_by_location_model.dart';
import 'package:goods/domain/repositories/home_repository.dart';
import 'package:goods/utils/failure.dart';

class GetAggAssetByStatusUseCase {
  final HomeRepository _repository;

  GetAggAssetByStatusUseCase(this._repository);

  Future<Either<Failure, AggAssetByLocationModel>> execute() {
    return _repository.getAggAssetByLocation();
  }
}
