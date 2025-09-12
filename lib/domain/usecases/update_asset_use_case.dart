import 'package:dartz/dartz.dart';
import 'package:goods/domain/models/asset_general_model.dart';
import 'package:goods/domain/repositories/asset_repository.dart';
import 'package:goods/utils/failure.dart';

class UpdateAssetUseCase {
  final AssetRepository _repository;

  UpdateAssetUseCase(this._repository);

  Future<Either<Failure, AssetGeneralModel>> execute(
    String id,
    String name,
    String statusId,
    String locationId,
  ) {
    return _repository.updateAsset(id, name, statusId, locationId);
  }
}
