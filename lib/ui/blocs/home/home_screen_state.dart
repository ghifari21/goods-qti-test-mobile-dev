part of 'home_screen_bloc.dart';

abstract class HomeScreenState extends Equatable {
  const HomeScreenState();

  @override
  List<Object> get props => [];
}

class HomeScreenInitial extends HomeScreenState {}

class HomeScreenLoading extends HomeScreenState {}

class HomeScreenLoaded extends HomeScreenState {
  final AggAssetByLocationModel aggAssetByLocation;
  final AggAssetByStatusModel aggAssetByStatus;
  final UserDetailModel userDetail;

  const HomeScreenLoaded({
    required this.aggAssetByLocation,
    required this.aggAssetByStatus,
    required this.userDetail,
  });

  @override
  List<Object> get props => [aggAssetByLocation, aggAssetByStatus, userDetail];
}

class HomeScreenLogOuted extends HomeScreenState {}

class HomeScreenError extends HomeScreenState {
  final String message;

  const HomeScreenError(this.message);

  @override
  List<Object> get props => [message];
}
