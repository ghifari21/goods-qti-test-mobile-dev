import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:goods/domain/models/asset_model.dart';
import 'package:goods/domain/models/common_model.dart';

class AssetResponse extends Equatable {
  final int count;
  final int pageCount;
  final int pageSize;
  final int page;
  final List<ResultAssetResponse> results;

  const AssetResponse({
    required this.count,
    required this.pageCount,
    required this.pageSize,
    required this.page,
    required this.results,
  });

  factory AssetResponse.fromRawJson(String str) =>
      AssetResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AssetResponse.fromJson(Map<String, dynamic> json) => AssetResponse(
    count: json["count"],
    pageCount: json["page_count"],
    pageSize: json["page_size"],
    page: json["page"],
    results: List<ResultAssetResponse>.from(
      json["results"].map((x) => ResultAssetResponse.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "page_count": pageCount,
    "page_size": pageSize,
    "page": page,
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
  };

  AssetModel toModel() {
    return AssetModel(
      count: count,
      pageCount: pageCount,
      pageSize: pageSize,
      page: page,
      results: results.map((e) => CommonModel(id: e.id, name: e.name)).toList(),
    );
  }

  @override
  List<Object> get props => [count, pageCount, pageSize, page, results];
}

class ResultAssetResponse extends Equatable {
  final String id;
  final String name;

  const ResultAssetResponse({required this.id, required this.name});

  factory ResultAssetResponse.fromRawJson(String str) =>
      ResultAssetResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ResultAssetResponse.fromJson(Map<String, dynamic> json) =>
      ResultAssetResponse(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id": id, "name": name};

  @override
  List<Object> get props => [id, name];
}
