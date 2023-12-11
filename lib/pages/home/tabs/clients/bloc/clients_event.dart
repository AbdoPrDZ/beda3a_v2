part of 'clients_bloc.dart';

@immutable
sealed class ClientsEvent {}

class GetClientsEvent extends ClientsEvent {}

class SearchClientsEvent extends ClientsEvent {
  final String searchText;

  SearchClientsEvent(this.searchText);

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

class CreateClientEvent extends ClientsEvent {}

class EditClientEvent extends ClientsEvent {
  final int clientId;

  EditClientEvent(this.clientId);
}

class ClearClientEvent extends ClientsEvent {}
