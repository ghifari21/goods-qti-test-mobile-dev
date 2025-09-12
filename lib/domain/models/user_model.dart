import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String email;
  final String username;
  final bool isActive;
  final String token;

  const UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.isActive,
    required this.token,
  });

  @override
  List<Object> get props => [id, email, username, isActive, token];
}
