part of 'edit_asset_screen_bloc.dart';

class EditAssetScreenState extends Equatable {
  const EditAssetScreenState();

  @override
  List<Object> get props => [];
}

class EditAssetScreenInitial extends EditAssetScreenState {}

class EditAssetScreenLoading extends EditAssetScreenState {}

class EditAssetScreenLoaded extends EditAssetScreenState {
  final List<CommonModel> locations;
  final List<CommonModel> statuses;
  final AssetDetailModel asset;

  const EditAssetScreenLoaded({
    required this.locations,
    required this.statuses,
    required this.asset,
  });

  @override
  List<Object> get props => [locations, statuses, asset];
}

class EditAssetScreenDeleteSuccess extends EditAssetScreenState {}

class EditAssetScreenUpdateSuccess extends EditAssetScreenState {}

class EditAssetScreenError extends EditAssetScreenState {
  final String message;

  const EditAssetScreenError(this.message);

  @override
  List<Object> get props => [message];
}
