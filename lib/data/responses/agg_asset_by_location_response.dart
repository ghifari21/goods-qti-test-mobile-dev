import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:goods/domain/models/agg_asset_by_location_model.dart';
import 'package:goods/domain/models/common_model.dart';

class AggAssetByLocationResponse extends Equatable {
  final List<ResultAssetLocationResponse> results;

  const AggAssetByLocationResponse({required this.results});

  factory AggAssetByLocationResponse.fromRawJson(String str) =>
      AggAssetByLocationResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AggAssetByLocationResponse.fromJson(Map<String, dynamic> json) =>
      AggAssetByLocationResponse(
        results: List<ResultAssetLocationResponse>.from(
          json["results"].map((x) => ResultAssetLocationResponse.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
  };

  AggAssetByLocationModel toModel() {
    return AggAssetByLocationModel(
      results: results.map((result) {
        return ResultAssetLocationModel(
          location: CommonModel(
            id: result.location.id,
            name: result.location.name,
          ),
          count: result.count,
        );
      }).toList(),
    );
  }

  @override
  List<Object> get props => [results];
}

class ResultAssetLocationResponse extends Equatable {
  final LocationAssetResponse location;
  final int count;

  const ResultAssetLocationResponse({
    required this.location,
    required this.count,
  });

  factory ResultAssetLocationResponse.fromRawJson(String str) =>
      ResultAssetLocationResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ResultAssetLocationResponse.fromJson(Map<String, dynamic> json) =>
      ResultAssetLocationResponse(
        location: LocationAssetResponse.fromJson(json["location"]),
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
    "location": location.toJson(),
    "count": count,
  };

  @override
  List<Object> get props => [location, count];
}

class LocationAssetResponse extends Equatable {
  final String id;
  final String name;

  const LocationAssetResponse({required this.id, required this.name});

  factory LocationAssetResponse.fromRawJson(String str) =>
      LocationAssetResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LocationAssetResponse.fromJson(Map<String, dynamic> json) =>
      LocationAssetResponse(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};

  @override
  List<Object> get props => [id, name];
}
