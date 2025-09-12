import 'package:dartz/dartz.dart';
import 'package:goods/domain/models/asset_general_model.dart';
import 'package:goods/domain/repositories/asset_repository.dart';
import 'package:goods/utils/failure.dart';

class CreateAssetUseCase {
  final AssetRepository _repository;

  CreateAssetUseCase(this._repository);

  Future<Either<Failure, AssetGeneralModel>> execute(
    String name,
    String statusId,
    String locationId,
  ) {
    return _repository.createAsset(name, statusId, locationId);
  }
}
