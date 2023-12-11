import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../src/src.dart';
import '../../../../create_edit_driver/controller.dart';

part 'drivers_event.dart';
part 'drivers_state.dart';

class DriversBloc extends Bloc<DriversEvent, DriversState> {
  DriversBloc() : super(const DriversInitState()) {
    on<DriversEvent>((event, emit) async {
      loading() => emit(const DriversLoadingState());
      loaded(List<DriverCollection> drivers) =>
          emit(DriversLoadedState(drivers));

      if (event is GetDriversEvent) {
        loading();
        loaded(await DriverModel.allWhere());
      } else if (event is SearchDriversEvent) {
        loading();
        loaded(
          await DriverModel.allWhere(where: event.getQuery()),
        );
      } else if (event is CreateDriverEvent) {
        loading();
        await RouteManager.to(PagesInfo.createEditDriver);
        loaded(await DriverModel.allWhere());
      } else if (event is EditDriverEvent) {
        loading();
        await RouteManager.to(
          PagesInfo.createEditDriver,
          arguments: CreateEditDriverData(
            action: CreateEditPageAction.edit,
            driverId: event.driverId,
          ),
        );
        loaded(await DriverModel.allWhere());
      } else if (event is ClearDriverEvent) {
        loading();
        await DriverModel.clear();
        loaded(await DriverModel.allWhere());
      }
    });
  }
}
