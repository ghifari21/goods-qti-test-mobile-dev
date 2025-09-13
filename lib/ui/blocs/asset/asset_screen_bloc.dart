import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:goods/domain/models/common_model.dart';
import 'package:goods/domain/usecases/get_all_assets_use_case.dart';
import 'package:goods/domain/usecases/search_assets_use_case.dart';

part 'asset_screen_event.dart';
part 'asset_screen_state.dart';

class AssetScreenBloc extends Bloc<AssetScreenEvent, AssetScreenState> {
  final GetAllAssetsUseCase getAllAssetsUseCase;
  final SearchAssetsUseCase searchAssetsUseCase;
  int _pageSize = 10;

  AssetScreenBloc({
    required this.getAllAssetsUseCase,
    required this.searchAssetsUseCase,
  }) : super(AssetScreenState()) {
    on<OnSearchEvent>(_onSearchEvent);
    on<RefreshDataEvent>(_refreshDataEvent);
    on<FetchDataEvent>(_onFetchDataEvent);
  }

  void _onSearchEvent(OnSearchEvent event, Emitter<AssetScreenState> emit) {
    emit(const AssetScreenState().copyWith(query: event.query));
    add(FetchDataEvent());
  }

  void _onFetchDataEvent(
    FetchDataEvent event,
    Emitter<AssetScreenState> emit,
  ) async {
    // do nothing if already reached max
    if (state.hasReachedMax) return;

    // set status to loading if initial
    if (state.status == AssetStatus.initial) {
      emit(state.copyWith(status: AssetStatus.loading));
    }

    // call use case to fetch data
    // based on whether query is empty or not
    final result = state.query.isEmpty
        ? await getAllAssetsUseCase.execute(state.currentPage, _pageSize)
        : await searchAssetsUseCase.execute(
            state.currentPage,
            _pageSize,
            state.query,
          );

    print(
      'FetchDataEvent: page=${state.currentPage}, query=${state.query}, result=$result',
    );

    // handle result
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: AssetStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (assetModel) {
        if (assetModel.results.isEmpty) {
          // if no data, set hasReachedMax to true
          emit(
            state.copyWith(hasReachedMax: true, status: AssetStatus.success),
          );
        } else {
          // if data available, append to list and update state
          final bool reachedMax = assetModel.results.length < _pageSize;
          emit(
            state.copyWith(
              status: AssetStatus.success,
              assets: List.of(state.assets)..addAll(assetModel.results),
              hasReachedMax: reachedMax,
              // if fetched less than page size, reached max
              currentPage:
                  state.currentPage + 1, // increment page for next fetch
            ),
          );
        }
      },
    );
  }

  void _refreshDataEvent(
    RefreshDataEvent event,
    Emitter<AssetScreenState> emit,
  ) async {
    emit(const AssetScreenState());
    add(FetchDataEvent());
  }
}
