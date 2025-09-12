import 'package:equatable/equatable.dart';

class AssetGeneralModel extends Equatable {
  final String id;
  final String name;
  final String statusId;
  final String locationId;

  const AssetGeneralModel({
    required this.id,
    required this.name,
    required this.statusId,
    required this.locationId,
  });

  @override
  List<Object> get props => [id, name, statusId, locationId];
}
