import 'package:equatable/equatable.dart';
import 'package:goods/domain/models/common_model.dart';

class AggAssetByLocationModel extends Equatable {
  final List<ResultAssetLocationModel> results;

  const AggAssetByLocationModel({required this.results});

  @override
  List<Object> get props => [results];
}

class ResultAssetLocationModel extends Equatable {
  final CommonModel location;
  final int count;

  const ResultAssetLocationModel({required this.location, required this.count});

  @override
  List<Object> get props => [location, count];
}
