part of 'asset_screen_bloc.dart';

enum AssetStatus { initial, loading, success, failure }

class AssetScreenState extends Equatable {
  final AssetStatus status;
  final List<CommonModel> assets;
  final String query;
  final bool hasReachedMax;
  final int currentPage;
  final String errorMessage;

  const AssetScreenState({
    this.status = AssetStatus.initial,
    this.assets = const <CommonModel>[],
    this.query = '',
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.errorMessage = '',
  });

  AssetScreenState copyWith({
    AssetStatus? status,
    List<CommonModel>? assets,
    String? query,
    bool? hasReachedMax,
    int? currentPage,
    String? errorMessage,
  }) {
    return AssetScreenState(
      status: status ?? this.status,
      assets: assets ?? this.assets,
      query: query ?? this.query,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
    status,
    assets,
    query,
    hasReachedMax,
    currentPage,
    errorMessage,
  ];
}
