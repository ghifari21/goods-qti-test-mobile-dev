import 'package:equatable/equatable.dart';
import 'package:goods/domain/models/common_model.dart';

class AggAssetByStatusModel extends Equatable {
  final List<ResultAssetStatusModel> results;

  const AggAssetByStatusModel({required this.results});

  @override
  List<Object> get props => [results];
}

class ResultAssetStatusModel extends Equatable {
  final CommonModel status;
  final int count;

  const ResultAssetStatusModel({required this.status, required this.count});

  @override
  List<Object> get props => [status, count];
}
