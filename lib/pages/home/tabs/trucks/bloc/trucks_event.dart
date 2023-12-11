part of 'trucks_bloc.dart';

@immutable
sealed class TrucksEvent {}

class GetTrucksEvent extends TrucksEvent {}

class SearchTrucksEvent extends TrucksEvent {
  final String searchText;

  SearchTrucksEvent(this.searchText);

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

class CreateTruckEvent extends TrucksEvent {}

class EditTruckEvent extends TrucksEvent {
  final int truckId;

  EditTruckEvent(this.truckId);
}

class ClearTruckEvent extends TrucksEvent {}
