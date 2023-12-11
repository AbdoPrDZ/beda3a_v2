import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../src/src.dart';
import '../../../../create_edit_trip/controller.dart';

part 'trips_event.dart';
part 'trips_state.dart';

class TripsBloc extends Bloc<TripsEvent, TripsState> {
  TripsBloc() : super(const TripsInitState()) {
    on<TripsEvent>((event, emit) async {
      loading() => emit(const TripsLoadingState());
      loaded(List<TripCollection> trips) => emit(TripsLoadedState(trips));

      if (event is GetTripsEvent) {
        loading();
        loaded(await TripModel.allWhere());
      } else if (event is SearchTripsEvent) {
        loading();
        loaded(
          await TripModel.allWhere(where: event.getQuery()),
        );
      } else if (event is CreateTripEvent) {
        loading();
        await RouteManager.to(
          PagesInfo.createEditTrip,
          arguments: CreateEditTripData(truckId: event.truckId),
        );
        loaded(await TripModel.allWhere());
      } else if (event is EditTripEvent) {
        loading();
        await RouteManager.to(
          PagesInfo.createEditTrip,
          arguments: CreateEditTripData(
            action: CreateEditPageAction.edit,
            tripId: event.tripId,
          ),
        );
        loaded(await TripModel.allWhere());
      } else if (event is ClearTripEvent) {
        loading();
        await TripModel.clear();
        loaded(await TripModel.allWhere());
      }
    });
  }
}
