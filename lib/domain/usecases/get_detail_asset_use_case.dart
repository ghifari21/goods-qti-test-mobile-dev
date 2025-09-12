import 'package:dartz/dartz.dart';
import 'package:goods/domain/models/asset_detail_model.dart';
import 'package:goods/domain/repositories/asset_repository.dart';
import 'package:goods/utils/failure.dart';

class GetDetailAssetUseCase {
  final AssetRepository _repository;

  GetDetailAssetUseCase(this._repository);

  Future<Either<Failure, AssetDetailModel>> execute(String id) {
    return _repository.getDetailAsset(id);
  }
}
