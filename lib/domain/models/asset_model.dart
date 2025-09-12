import 'package:equatable/equatable.dart';
import 'package:goods/domain/models/common_model.dart';

class AssetModel extends Equatable {
  final int count;
  final int pageCount;
  final int pageSize;
  final int page;
  final List<CommonModel> results;

  const AssetModel({
    required this.count,
    required this.pageCount,
    required this.pageSize,
    required this.page,
    required this.results,
  });

  @override
  List<Object> get props => [count, pageCount, pageSize, page, results];
}
