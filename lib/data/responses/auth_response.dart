import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:goods/domain/models/user_model.dart';

class AuthResponse extends Equatable {
  final String id;
  final String email;
  final String username;
  final bool isActive;
  final String token;

  const AuthResponse({
    required this.id,
    required this.email,
    required this.username,
    required this.isActive,
    required this.token,
  });

  factory AuthResponse.fromRawJson(String str) =>
      AuthResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
    id: json["id"],
    email: json["email"],
    username: json["username"],
    isActive: json["is_active"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "username": username,
    "is_active": isActive,
    "token": token,
  };

  UserModel toModel() {
    return UserModel(
      id: id,
      email: email,
      username: username,
      isActive: isActive,
      token: token,
    );
  }

  @override
  List<Object> get props => [id, email, username, isActive, token];
}
