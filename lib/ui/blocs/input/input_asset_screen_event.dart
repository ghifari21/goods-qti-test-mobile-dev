part of 'input_asset_screen_bloc.dart';

abstract class InputAssetScreenEvent extends Equatable {
  const InputAssetScreenEvent();

  @override
  List<Object> get props => [];
}

class FetchStatusAndLocationEvent extends InputAssetScreenEvent {}

class OnSubmitButtonPressedEvent extends InputAssetScreenEvent {
  final String name;
  final String statusId;
  final String locationId;

  const OnSubmitButtonPressedEvent({
    required this.name,
    required this.statusId,
    required this.locationId,
  });

  @override
  List<Object> get props => [name, statusId, locationId];
}
