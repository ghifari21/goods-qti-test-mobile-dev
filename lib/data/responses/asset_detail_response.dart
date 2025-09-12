import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:goods/domain/models/asset_detail_model.dart';
import 'package:goods/domain/models/common_model.dart';

class AssetDetailResponse extends Equatable {
  final String id;
  final String name;
  final ResultResponse status;
  final ResultResponse location;

  const AssetDetailResponse({
    required this.id,
    required this.name,
    required this.status,
    required this.location,
  });

  factory AssetDetailResponse.fromRawJson(String str) =>
      AssetDetailResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AssetDetailResponse.fromJson(Map<String, dynamic> json) =>
      AssetDetailResponse(
        id: json["id"],
        name: json["name"],
        status: ResultResponse.fromJson(json["status"]),
        location: ResultResponse.fromJson(json["location"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "status": status.toJson(),
    "location": location.toJson(),
  };

  AssetDetailModel toModel() {
    return AssetDetailModel(
      id: id,
      name: name,
      status: CommonModel(id: status.id, name: status.name),
      location: CommonModel(id: location.id, name: location.name),
    );
  }

  @override
  List<Object> get props => [id, name, status, location];
}

class ResultResponse extends Equatable {
  final String id;
  final String name;

  const ResultResponse({required this.id, required this.name});

  factory ResultResponse.fromRawJson(String str) =>
      ResultResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ResultResponse.fromJson(Map<String, dynamic> json) =>
      ResultResponse(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};

  @override
  List<Object> get props => [id, name];
}
