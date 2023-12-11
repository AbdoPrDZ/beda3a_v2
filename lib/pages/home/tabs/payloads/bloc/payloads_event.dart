part of 'payloads_bloc.dart';

@immutable
sealed class PayloadsEvent {}

class GetPayloadsEvent extends PayloadsEvent {}

class SearchPayloadsEvent extends PayloadsEvent {
  final String searchText;

  SearchPayloadsEvent(this.searchText);

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

class CreatePayloadEvent extends PayloadsEvent {}

class EditPayloadEvent extends PayloadsEvent {
  final int payloadId;

  EditPayloadEvent(this.payloadId);
}

class ClearPayloadEvent extends PayloadsEvent {}
