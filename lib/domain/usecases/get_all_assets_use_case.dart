import 'package:dartz/dartz.dart';
import 'package:goods/domain/models/asset_model.dart';
import 'package:goods/domain/repositories/asset_repository.dart';
import 'package:goods/utils/failure.dart';

class GetAllAssetsUseCase {
  final AssetRepository _repository;

  GetAllAssetsUseCase(this._repository);

  Future<Either<Failure, AssetModel>> execute(int page, int size) {
    return _repository.getAllAssets(page, size);
  }
}
