import 'package:equatable/equatable.dart';

class UserDetailModel extends Equatable {
  final String id;
  final String email;
  final String username;
  final bool isActive;
  final String refreshedToken;

  const UserDetailModel({
    required this.id,
    required this.email,
    required this.username,
    required this.isActive,
    required this.refreshedToken,
  });

  @override
  List<Object> get props => [id, email, username, isActive, refreshedToken];
}
