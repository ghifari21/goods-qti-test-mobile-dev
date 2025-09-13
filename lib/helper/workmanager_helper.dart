import 'package:goods/di/injection.dart';
import 'package:goods/ui/blocs/home/home_screen_bloc.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await setupLocator();
    await getIt.allReady();

    final homeScreenBloc = getIt<HomeScreenBloc>();

    try {
      homeScreenBloc.add(FetchHomeDataEvent());
      print("Background task: fetch chart status success");
      return Future.value(true);
    } catch (e) {
      print("Background task error: $e");
      return Future.value(false);
    }
  });
}

class WorkmanagerHelper {
  final Workmanager _workmanager;

  WorkmanagerHelper([Workmanager? workmanager])
    : _workmanager = workmanager ??= Workmanager();

  Future<void> init() async {
    await _workmanager.initialize(callbackDispatcher);
  }

  Future<void> runOneOffTask() async {
    await _workmanager.registerOneOffTask(
      "12",
      "fetch",
      constraints: Constraints(networkType: NetworkType.connected),
      initialDelay: const Duration(seconds: 5),
      inputData: {
        "data": "This is a valid payload from oneoff task workmanager",
      },
    );
  }

  Future<void> runPeriodicTask() async {
    await _workmanager.registerPeriodicTask(
      "1",
      "fetchChartStatus",
      frequency: const Duration(minutes: 15), // minimum 15 minutes
      initialDelay: Duration.zero,
      constraints: Constraints(networkType: NetworkType.connected),
    );
  }

  Future<void> cancelAllTask() async {
    await _workmanager.cancelAll();
  }
}
