part of 'input_asset_screen_bloc.dart';

abstract class InputAssetScreenState extends Equatable {
  const InputAssetScreenState();

  @override
  List<Object> get props => [];
}

class InputAssetScreenInitial extends InputAssetScreenState {}

class InputAssetScreenLoading extends InputAssetScreenState {}

class InputAssetScreenSubmitLoading extends InputAssetScreenState {}

class InputAssetScreenError extends InputAssetScreenState {
  final String message;

  const InputAssetScreenError(this.message);

  @override
  List<Object> get props => [message];
}

class InputAssetScreenLoaded extends InputAssetScreenState {
  final List<CommonModel> locations;
  final List<CommonModel> statuses;

  const InputAssetScreenLoaded({
    required this.locations,
    required this.statuses,
  });

  @override
  List<Object> get props => [locations, statuses];
}

class InputAssetScreenSuccess extends InputAssetScreenState {}
