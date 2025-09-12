import 'package:dartz/dartz.dart';
import 'package:goods/domain/models/asset_model.dart';
import 'package:goods/domain/repositories/asset_repository.dart';
import 'package:goods/utils/failure.dart';

class SearchAssetsUseCase {
  final AssetRepository _repository;

  SearchAssetsUseCase(this._repository);

  Future<Either<Failure, AssetModel>> execute(
    int page,
    int size,
    String query,
  ) {
    return _repository.searchAssets(page, size, query);
  }
}
