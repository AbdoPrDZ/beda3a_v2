part of 'drivers_bloc.dart';

@immutable
sealed class DriversState {
  const DriversState();
}

class DriversInitState extends DriversState {
  const DriversInitState();
}

class DriversLoadingState extends DriversState {
  const DriversLoadingState();
}

class DriversLoadedState extends DriversState {
  final List<DriverCollection> drivers;

  const DriversLoadedState(this.drivers);
}
