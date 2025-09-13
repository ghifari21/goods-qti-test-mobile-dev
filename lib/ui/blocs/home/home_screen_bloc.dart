import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:goods/domain/models/agg_asset_by_location_model.dart';
import 'package:goods/domain/models/agg_asset_by_status_model.dart';
import 'package:goods/domain/models/user_detail_model.dart';
import 'package:goods/domain/usecases/get_agg_asset_by_location_use_case.dart';
import 'package:goods/domain/usecases/get_agg_asset_by_status_use_case.dart';
import 'package:goods/domain/usecases/get_user_details_use_case.dart';
import 'package:goods/domain/usecases/logout_use_case.dart';

part 'home_screen_event.dart';
part 'home_screen_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  final GetAggAssetByLocationUseCase getAggAssetByLocationUseCase;
  final GetAggAssetByStatusUseCase getAggAssetByStatusUseCase;
  final GetUserDetailsUseCase getUserDetailsUseCase;
  final LogoutUseCase logoutUseCase;

  HomeScreenBloc({
    required this.getAggAssetByLocationUseCase,
    required this.getAggAssetByStatusUseCase,
    required this.getUserDetailsUseCase,
    required this.logoutUseCase,
  }) : super(HomeScreenInitial()) {
    on<FetchHomeDataEvent>((event, emit) async {
      emit(HomeScreenLoading());

      final userDetailsResult = await getUserDetailsUseCase.execute();
      final aggAssetByStatusResult = await getAggAssetByStatusUseCase.execute();
      final aggAssetByLocationResult = await getAggAssetByLocationUseCase
          .execute();

      aggAssetByStatusResult.fold(
        (failure) => emit(HomeScreenError(failure.message)),
        (aggAssetByStatus) {
          aggAssetByLocationResult.fold(
            (failure) => emit(HomeScreenError(failure.message)),
            (aggAssetByLocation) {
              userDetailsResult.fold(
                (failure) => emit(HomeScreenError(failure.message)),
                (userDetail) {
                  emit(
                    HomeScreenLoaded(
                      aggAssetByLocation: aggAssetByLocation,
                      aggAssetByStatus: aggAssetByStatus,
                      userDetail: userDetail,
                    ),
                  );
                },
              );
            },
          );
        },
      );
    });

    on<LogoutEvent>((event, emit) async {
      emit(HomeScreenLoading());

      final result = await logoutUseCase.execute();

      result.fold(
        (failure) => emit(HomeScreenError(failure.message)),
        (_) => emit(HomeScreenLogOuted()),
      );
    });
  }
}
