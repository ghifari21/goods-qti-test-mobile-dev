import 'package:equatable/equatable.dart';
import 'package:goods/domain/models/common_model.dart';

class GeneralModel extends Equatable {
  final List<CommonModel> results;

  const GeneralModel({required this.results});

  @override
  List<Object> get props => [results];
}
