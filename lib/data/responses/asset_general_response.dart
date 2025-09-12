import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:goods/domain/models/asset_general_model.dart';

class AssetGeneralResponse extends Equatable {
  final String id;
  final String name;
  final String statusId;
  final String locationId;

  const AssetGeneralResponse({
    required this.id,
    required this.name,
    required this.statusId,
    required this.locationId,
  });

  factory AssetGeneralResponse.fromRawJson(String str) =>
      AssetGeneralResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AssetGeneralResponse.fromJson(Map<String, dynamic> json) =>
      AssetGeneralResponse(
        id: json["id"],
        name: json["name"],
        statusId: json["status_id"],
        locationId: json["location_id"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "status_id": statusId,
    "location_id": locationId,
  };

  AssetGeneralModel toModel() {
    return AssetGeneralModel(
      id: id,
      name: name,
      statusId: statusId,
      locationId: locationId,
    );
  }

  @override
  List<Object> get props => [id, name, statusId, locationId];
}
