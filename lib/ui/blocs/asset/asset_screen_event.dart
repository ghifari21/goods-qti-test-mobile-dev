part of 'asset_screen_bloc.dart';

abstract class AssetScreenEvent extends Equatable {
  const AssetScreenEvent();

  @override
  List<Object> get props => [];
}

class FetchDataEvent extends AssetScreenEvent {}

class RefreshDataEvent extends AssetScreenEvent {}

class OnSearchEvent extends AssetScreenEvent {
  final String query;

  const OnSearchEvent(this.query);

  @override
  List<Object> get props => [query];
}
