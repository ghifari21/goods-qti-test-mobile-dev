import 'package:dartz/dartz.dart';
import 'package:goods/domain/repositories/asset_repository.dart';
import 'package:goods/utils/failure.dart';

class DeleteAssetUseCase {
  final AssetRepository _repository;

  DeleteAssetUseCase(this._repository);

  Future<Either<Failure, String>> execute(String id) {
    return _repository.deleteAsset(id);
  }
}
