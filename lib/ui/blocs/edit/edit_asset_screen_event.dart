part of 'edit_asset_screen_bloc.dart';

abstract class EditAssetScreenEvent extends Equatable {
  const EditAssetScreenEvent();

  @override
  List<Object> get props => [];
}

class FetchAllDataEvent extends EditAssetScreenEvent {
  final String assetId;

  const FetchAllDataEvent(this.assetId);

  @override
  List<Object> get props => [assetId];
}

class DeleteAssetEvent extends EditAssetScreenEvent {
  final String assetId;

  const DeleteAssetEvent(this.assetId);

  @override
  List<Object> get props => [assetId];
}

class UpdateAssetEvent extends EditAssetScreenEvent {
  final String assetId;
  final String name;
  final String statusId;
  final String locationId;

  const UpdateAssetEvent({
    required this.assetId,
    required this.name,
    required this.statusId,
    required this.locationId,
  });

  @override
  List<Object> get props => [assetId, name, statusId, locationId];
}
