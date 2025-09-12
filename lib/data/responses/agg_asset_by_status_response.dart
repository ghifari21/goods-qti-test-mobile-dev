import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:goods/domain/models/agg_asset_by_status_model.dart';
import 'package:goods/domain/models/common_model.dart';

class AggAssetByStatusResponse extends Equatable {
  final List<ResultAssetStatusResponse> results;

  const AggAssetByStatusResponse({required this.results});

  factory AggAssetByStatusResponse.fromRawJson(String str) =>
      AggAssetByStatusResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AggAssetByStatusResponse.fromJson(Map<String, dynamic> json) =>
      AggAssetByStatusResponse(
        results: List<ResultAssetStatusResponse>.from(
          json["results"].map((x) => ResultAssetStatusResponse.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
  };

  AggAssetByStatusModel toModel() {
    return AggAssetByStatusModel(
      results: results.map((result) {
        return ResultAssetStatusModel(
          status: CommonModel(id: result.status.id, name: result.status.name),
          count: result.count,
        );
      }).toList(),
    );
  }

  @override
  List<Object> get props => [results];
}

class ResultAssetStatusResponse extends Equatable {
  final StatusAssetResponse status;
  final int count;

  const ResultAssetStatusResponse({required this.status, required this.count});

  factory ResultAssetStatusResponse.fromRawJson(String str) =>
      ResultAssetStatusResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ResultAssetStatusResponse.fromJson(Map<String, dynamic> json) =>
      ResultAssetStatusResponse(
        status: StatusAssetResponse.fromJson(json["status"]),
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {"status": status.toJson(), "count": count};

  @override
  List<Object> get props => [status, count];
}

class StatusAssetResponse extends Equatable {
  final String id;
  final String name;

  const StatusAssetResponse({required this.id, required this.name});

  factory StatusAssetResponse.fromRawJson(String str) =>
      StatusAssetResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory StatusAssetResponse.fromJson(Map<String, dynamic> json) =>
      StatusAssetResponse(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};

  @override
  List<Object> get props => [id, name];
}
