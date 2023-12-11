import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../src/src.dart';
import 'bloc/clients_bloc.dart';

class ClientsTab extends BlocPage<ClientsBloc, ClientsEvent, ClientsState> {
  ClientsTab({Key? key})
      : super(
          key: key,
          getBloc: (context) => ClientsBloc(),
        );

  final searchController = TextEditController();

  @override
  Widget? buildFloatingActionButton(BuildContext context) =>
      BlocBuilder<ClientsBloc, ClientsState>(
        builder: (context, state) => Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 'create_client',
              backgroundColor: UIThemeColors.iconBg,
              onPressed: () {
                callEvent(context, CreateClientEvent());
              },
              child: const Icon(Icons.person_add_alt),
            ),
            const Gap(10),
            FloatingActionButton(
              heroTag: 'clear_clients',
              backgroundColor: UIThemeColors.danger,
              onPressed: () {
                callEvent(context, ClearClientEvent());
              },
              child: const Icon(Icons.clear_all),
            ),
          ],
        ),
      );

  Widget _buildItem(BuildContext context, ClientCollection client) => InkWell(
        onTap: () {
          BlocProvider.of<ClientsBloc>(context).add(EditClientEvent(client.id));
        },
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          child: Flex(
            direction: Axis.horizontal,
            children: [
              UserAvatarView.label(getNameSymbols(
                client.fullName,
              )),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: client.fullName,
                      style: TextStyle(
                        color: UIThemeColors.text2,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '\n${client.createdAt}',
                      style: TextStyle(
                        color: UIThemeColors.text3,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  @override
  Widget buildBody(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: BlocBuilder<ClientsBloc, ClientsState>(
          builder: (context, state) {
            if (state is ClientsInitState) {
              callEvent(context, GetClientsEvent());
            }
            return Column(
              children: [
                TextEditView(
                  controller: searchController,
                  onSuffixPress: () {
                    callEvent(
                      context,
                      SearchClientsEvent(searchController.text),
                    );
                  },
                  suffixIcon: Icons.search,
                  hint: 'Type to search for client...',
                ),
                SingleChildScrollView(
                  child: (state is ClientsLoadedState)
                      ? Flex(
                          direction: Axis.vertical,
                          children: [
                            for (ClientCollection client in state.clients)
                              _buildItem(context, client)
                          ],
                        )
                      : const Center(child: CircularProgressIndicator()),
                ),
              ],
            );
          },
        ),
      );
}
