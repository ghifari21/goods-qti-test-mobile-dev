import 'package:equatable/equatable.dart';
import 'package:goods/domain/models/common_model.dart';

class AssetDetailModel extends Equatable {
  final String id;
  final String name;
  final CommonModel status;
  final CommonModel location;

  const AssetDetailModel({
    required this.id,
    required this.name,
    required this.status,
    required this.location,
  });

  @override
  List<Object> get props => [id, name, status, location];
}
