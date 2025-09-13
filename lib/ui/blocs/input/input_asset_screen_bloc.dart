import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:goods/domain/models/common_model.dart';
import 'package:goods/domain/usecases/create_asset_use_case.dart';
import 'package:goods/domain/usecases/get_all_locations_use_case.dart';
import 'package:goods/domain/usecases/get_all_statuses_use_case.dart';

part 'input_asset_screen_event.dart';
part 'input_asset_screen_state.dart';

class InputAssetScreenBloc
    extends Bloc<InputAssetScreenEvent, InputAssetScreenState> {
  final GetAllLocationsUseCase getAllLocationsUseCase;
  final GetAllStatusesUseCase getAllStatusesUseCase;
  final CreateAssetUseCase createAssetUseCase;

  InputAssetScreenBloc({
    required this.getAllLocationsUseCase,
    required this.getAllStatusesUseCase,
    required this.createAssetUseCase,
  }) : super(InputAssetScreenInitial()) {
    on<FetchStatusAndLocationEvent>(_fetchStatusAndLocation);
    on<OnSubmitButtonPressedEvent>(_onSubmitButtonPressed);
  }

  void _fetchStatusAndLocation(
    FetchStatusAndLocationEvent event,
    Emitter<InputAssetScreenState> emit,
  ) async {
    emit(InputAssetScreenLoading());

    final locationsResult = await getAllLocationsUseCase.execute();
    final statusesResult = await getAllStatusesUseCase.execute();

    locationsResult.fold(
      (failure) => emit(InputAssetScreenError(failure.message)),
      (locations) {
        statusesResult.fold(
          (failure) => emit(InputAssetScreenError(failure.message)),
          (statuses) {
            emit(
              InputAssetScreenLoaded(
                locations: locations.results,
                statuses: statuses.results,
              ),
            );
          },
        );
      },
    );
  }

  void _onSubmitButtonPressed(
    OnSubmitButtonPressedEvent event,
    Emitter<InputAssetScreenState> emit,
  ) async {
    emit(InputAssetScreenSubmitLoading());

    final createResult = await createAssetUseCase.execute(
      event.name,
      event.statusId,
      event.locationId,
    );

    createResult.fold(
      (failure) => emit(InputAssetScreenError(failure.message)),
      (_) {
        emit(InputAssetScreenSuccess());
        add(FetchStatusAndLocationEvent());
      },
    );
  }
}
