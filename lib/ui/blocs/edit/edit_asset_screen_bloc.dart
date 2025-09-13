import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:goods/domain/models/asset_detail_model.dart';
import 'package:goods/domain/models/common_model.dart';
import 'package:goods/domain/usecases/delete_asset_use_case.dart';
import 'package:goods/domain/usecases/get_all_locations_use_case.dart';
import 'package:goods/domain/usecases/get_all_statuses_use_case.dart';
import 'package:goods/domain/usecases/get_detail_asset_use_case.dart';
import 'package:goods/domain/usecases/update_asset_use_case.dart';

part 'edit_asset_screen_event.dart';
part 'edit_asset_screen_state.dart';

class EditAssetScreenBloc
    extends Bloc<EditAssetScreenEvent, EditAssetScreenState> {
  final GetDetailAssetUseCase getDetailAssetUseCase;
  final GetAllLocationsUseCase getAllLocationsUseCase;
  final GetAllStatusesUseCase getAllStatusesUseCase;
  final UpdateAssetUseCase updateAssetUseCase;
  final DeleteAssetUseCase deleteAssetUseCase;

  EditAssetScreenBloc({
    required this.getDetailAssetUseCase,
    required this.getAllLocationsUseCase,
    required this.getAllStatusesUseCase,
    required this.updateAssetUseCase,
    required this.deleteAssetUseCase,
  }) : super(EditAssetScreenInitial()) {
    on<FetchAllDataEvent>(_fetchData);
    on<DeleteAssetEvent>(_deleteAsset);
    on<UpdateAssetEvent>(_updateAsset);
  }

  void _fetchData(
    FetchAllDataEvent event,
    Emitter<EditAssetScreenState> emit,
  ) async {
    emit(EditAssetScreenLoading());

    final assetResult = await getDetailAssetUseCase.execute(event.assetId);
    final locationsResult = await getAllLocationsUseCase.execute();
    final statusesResult = await getAllStatusesUseCase.execute();

    assetResult.fold((failure) => emit(EditAssetScreenError(failure.message)), (
      asset,
    ) {
      locationsResult.fold(
        (failure) => emit(EditAssetScreenError(failure.message)),
        (locations) {
          statusesResult.fold(
            (failure) => emit(EditAssetScreenError(failure.message)),
            (statuses) {
              emit(
                EditAssetScreenLoaded(
                  asset: asset,
                  locations: locations.results,
                  statuses: statuses.results,
                ),
              );
            },
          );
        },
      );
    });
  }

  void _deleteAsset(
    DeleteAssetEvent event,
    Emitter<EditAssetScreenState> emit,
  ) async {
    emit(EditAssetScreenLoading());

    final deleteResult = await deleteAssetUseCase.execute(event.assetId);

    deleteResult.fold(
      (failure) => emit(EditAssetScreenError(failure.message)),
      (success) => emit(EditAssetScreenDeleteSuccess()),
    );
  }

  void _updateAsset(
    UpdateAssetEvent event,
    Emitter<EditAssetScreenState> emit,
  ) async {
    emit(EditAssetScreenLoading());

    final updateResult = await updateAssetUseCase.execute(
      event.assetId,
      event.name,
      event.statusId,
      event.locationId,
    );

    updateResult.fold(
      (failure) => emit(EditAssetScreenError(failure.message)),
      (success) {
        emit(EditAssetScreenUpdateSuccess());
        add(FetchAllDataEvent(event.assetId));
      },
    );
  }
}
