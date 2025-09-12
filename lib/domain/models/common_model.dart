import 'package:equatable/equatable.dart';

class CommonModel extends Equatable {
  final String id;
  final String name;

  const CommonModel({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}
