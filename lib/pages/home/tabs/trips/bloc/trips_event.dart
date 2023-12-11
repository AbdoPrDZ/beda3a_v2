part of 'trips_bloc.dart';

@immutable
sealed class TripsEvent {
  const TripsEvent();
}

class GetTripsEvent extends TripsEvent {}

class SearchTripsEvent extends TripsEvent {
  final String searchText;

  const SearchTripsEvent(this.searchText);

  WhereQuery? getQuery() {
    if (searchText.isNotEmpty) {
      return WhereQuery.create(
        WhereQueryItemCondition.like(
          column: 'users.first_name',
          value: '%$searchText%',
          stringCase: StringCase.lower,
        ),
      ).or(
        WhereQueryItemCondition.like(
          column: 'users.last_name',
          value: '%$searchText%',
          stringCase: StringCase.lower,
        ),
      );
    }
    return null;
  }
}

class CreateTripEvent extends TripsEvent {
  final int truckId;

  const CreateTripEvent(this.truckId);
}

class EditTripEvent extends TripsEvent {
  final int tripId;

  const EditTripEvent(this.tripId);
}

class ClearTripEvent extends TripsEvent {}
