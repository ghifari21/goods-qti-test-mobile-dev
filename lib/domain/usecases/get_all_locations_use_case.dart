import 'package:dartz/dartz.dart';
import 'package:goods/domain/models/general_model.dart';
import 'package:goods/domain/repositories/home_repository.dart';
import 'package:goods/utils/failure.dart';

class GetAllLocationsUseCase {
  final HomeRepository _repository;

  GetAllLocationsUseCase(this._repository);

  Future<Either<Failure, GeneralModel>> execute() {
    return _repository.getAllLocations();
  }
}
