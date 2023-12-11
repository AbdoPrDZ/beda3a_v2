part of 'drivers_bloc.dart';

@immutable
sealed class DriversEvent {}

class GetDriversEvent extends DriversEvent {}

class SearchDriversEvent extends DriversEvent {
  final String searchText;

  SearchDriversEvent(this.searchText);

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

class CreateDriverEvent extends DriversEvent {}

class EditDriverEvent extends DriversEvent {
  final int driverId;

  EditDriverEvent(this.driverId);
}

class ClearDriverEvent extends DriversEvent {}
