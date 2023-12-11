part of 'trip_button_bloc.dart';

@immutable
sealed class TripButtonEvent {
  const TripButtonEvent();
}

class LoadTruckEvent extends TripButtonEvent {
  final TickerProvider vsync;
  const LoadTruckEvent(this.vsync);
}

class CreateTripEvent extends TripButtonEvent {
  const CreateTripEvent();
}

class EditTripEvent extends TripButtonEvent {
  const EditTripEvent();
}

class StartTripEvent extends TripButtonEvent {
  const StartTripEvent();
}

class EndTripEvent extends TripButtonEvent {
  const EndTripEvent();
}

class DoneTripEvent extends TripButtonEvent {
  const DoneTripEvent();
}
