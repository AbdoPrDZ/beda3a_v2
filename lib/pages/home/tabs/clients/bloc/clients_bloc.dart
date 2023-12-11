import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../src/src.dart';
import '../../../../create_edit_client/controller.dart';

part 'clients_event.dart';
part 'clients_state.dart';

class ClientsBloc extends Bloc<ClientsEvent, ClientsState> {
  ClientsBloc() : super(const ClientsInitState()) {
    on<ClientsEvent>((event, emit) async {
      loading() => emit(const ClientsLoadingState());
      loaded(List<ClientCollection> clients) =>
          emit(ClientsLoadedState(clients));

      if (event is GetClientsEvent) {
        loading();
        loaded(await ClientModel.allWhere());
      } else if (event is SearchClientsEvent) {
        loading();
        loaded(
          await ClientModel.allWhere(where: event.getQuery()),
        );
      } else if (event is CreateClientEvent) {
        loading();
        await RouteManager.to(PagesInfo.createEditClient);
        loaded(await ClientModel.allWhere());
      } else if (event is EditClientEvent) {
        loading();
        await RouteManager.to(
          PagesInfo.createEditClient,
          arguments: CreateEditClientData(
            action: CreateEditPageAction.edit,
            clientId: event.clientId,
          ),
        );
        loaded(await ClientModel.allWhere());
      } else if (event is ClearClientEvent) {
        loading();
        await ClientModel.clear();
        loaded(await ClientModel.allWhere());
      }
    });
  }
}
