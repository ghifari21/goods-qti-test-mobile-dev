import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:goods/domain/models/common_model.dart';
import 'package:goods/domain/models/general_model.dart';

class GeneralResponse extends Equatable {
  final List<ResultResponse> results;

  const GeneralResponse({required this.results});

  factory GeneralResponse.fromRawJson(String str) =>
      GeneralResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory GeneralResponse.fromJson(Map<String, dynamic> json) =>
      GeneralResponse(
        results: List<ResultResponse>.from(
          json["results"].map((x) => ResultResponse.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
  };

  GeneralModel toModel() {
    return GeneralModel(
      results: results.map((e) => CommonModel(id: e.id, name: e.name)).toList(),
    );
  }

  @override
  List<Object> get props => [results];
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
