import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../src/src.dart';
import '../../../../create_edit_truck/controller.dart';
import '../../../controller.dart';

part 'trucks_event.dart';
part 'trucks_state.dart';

class TrucksBloc extends Bloc<TrucksEvent, TrucksState> {
  TrucksBloc(HomeController homeController) : super(const TrucksInitState()) {
    on<TrucksEvent>((event, emit) async {
      loading() => emit(const TrucksLoadingState());
      loaded(List<TruckCollection> trucks) => emit(TrucksLoadedState(trucks));

      if (event is GetTrucksEvent) {
        loading();
        loaded(await TruckModel.all());
      } else if (event is SearchTrucksEvent) {
        loading();
        loaded(
          await TruckModel.allWhere(where: event.getQuery()),
        );
      } else if (event is CreateTruckEvent) {
        loading();
        await RouteManager.to(PagesInfo.createEditTruck);
        await homeController.getTrucks();
        loaded(await TruckModel.all());
      } else if (event is EditTruckEvent) {
        loading();
        await RouteManager.to(
          PagesInfo.createEditTruck,
          arguments: CreateEditTruckData(
            action: CreateEditPageAction.edit,
            truckId: event.truckId,
          ),
        );
        loaded(await TruckModel.all());
        await homeController.getTrucks();
      } else if (event is ClearTruckEvent) {
        loading();
        await TruckModel.clear();
        loaded(await TruckModel.all());
        await homeController.getTrucks();
      }
    });
  }
}
