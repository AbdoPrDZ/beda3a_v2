part of 'trips_bloc.dart';

@immutable
sealed class TripsState {
  const TripsState();
}

class TripsInitState extends TripsState {
  const TripsInitState();
}

class TripsLoadingState extends TripsState {
  const TripsLoadingState();
}

class TripsLoadedState extends TripsState {
  final List<TripCollection> trips;

  const TripsLoadedState(this.trips);
}
