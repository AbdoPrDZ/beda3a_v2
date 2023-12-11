part of 'trucks_bloc.dart';

@immutable
sealed class TrucksState {
  const TrucksState();
}

class TrucksInitState extends TrucksState {
  const TrucksInitState();
}

class TrucksLoadingState extends TrucksState {
  const TrucksLoadingState();
}

class TrucksLoadedState extends TrucksState {
  final List<TruckCollection> trucks;

  const TrucksLoadedState(this.trucks);
}
