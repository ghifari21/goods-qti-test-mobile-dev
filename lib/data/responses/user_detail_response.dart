import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:goods/domain/models/user_detail_model.dart';

class UserDetailResponse extends Equatable {
  final String id;
  final String email;
  final String username;
  final bool isActive;
  final String refreshedToken;

  const UserDetailResponse({
    required this.id,
    required this.email,
    required this.username,
    required this.isActive,
    required this.refreshedToken,
  });

  factory UserDetailResponse.fromRawJson(String str) =>
      UserDetailResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserDetailResponse.fromJson(Map<String, dynamic> json) =>
      UserDetailResponse(
        id: json["id"],
        email: json["email"],
        username: json["username"],
        isActive: json["is_active"],
        refreshedToken: json["refreshed_token"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "username": username,
    "is_active": isActive,
    "refreshed_token": refreshedToken,
  };

  UserDetailModel toModel() {
    return UserDetailModel(
      id: id,
      email: email,
      username: username,
      isActive: isActive,
      refreshedToken: refreshedToken,
    );
  }

  @override
  List<Object> get props => [id, email, username, isActive, refreshedToken];
}
