part of 'clients_bloc.dart';

@immutable
sealed class ClientsState {
  const ClientsState();
}

class ClientsInitState extends ClientsState {
  const ClientsInitState();
}

class ClientsLoadingState extends ClientsState {
  const ClientsLoadingState();
}

class ClientsLoadedState extends ClientsState {
  final List<ClientCollection> clients;

  const ClientsLoadedState(this.clients);
}
