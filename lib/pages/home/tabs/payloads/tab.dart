import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../src/src.dart';
import 'bloc/payloads_bloc.dart';

class PayloadsTab extends BlocPage<PayloadsBloc, PayloadsEvent, PayloadsState> {
  PayloadsTab({Key? key})
      : super(
          key: key,
          getBloc: (context) => PayloadsBloc(),
        );

  final searchController = TextEditController();

  @override
  Widget? buildFloatingActionButton(BuildContext context) =>
      BlocBuilder<PayloadsBloc, PayloadsState>(
        builder: (context, state) => Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 'create_payload',
              backgroundColor: UIThemeColors.iconBg,
              onPressed: () {
                callEvent(context, CreatePayloadEvent());
              },
              child: const Icon(Icons.apps),
            ),
            const Gap(10),
            FloatingActionButton(
              heroTag: 'clear_payloads',
              backgroundColor: UIThemeColors.danger,
              onPressed: () {
                callEvent(context, ClearPayloadEvent());
              },
              child: const Icon(Icons.clear_all),
            ),
          ],
        ),
      );

  Widget _buildItem(BuildContext context, PayloadCollection payload) => InkWell(
        onTap: () => callEvent(context, EditPayloadEvent(payload.id)),
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          child: Flex(
            direction: Axis.horizontal,
            children: [
              UserAvatarView.label(getNameSymbols(
                payload.name,
              )),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: payload.name,
                      style: TextStyle(
                        color: UIThemeColors.text2,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '\n${payload.createdAt}',
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
        child: BlocBuilder<PayloadsBloc, PayloadsState>(
          builder: (context, state) {
            if (state is PayloadsInitState) {
              callEvent(context, GetPayloadsEvent());
            }
            return Column(
              children: [
                TextEditView(
                  controller: searchController,
                  onSuffixPress: () {
                    callEvent(
                      context,
                      SearchPayloadsEvent(searchController.text),
                    );
                  },
                  suffixIcon: Icons.search,
                  hint: 'Type to search for payload...',
                ),
                SingleChildScrollView(
                  child: (state is PayloadsLoadedState)
                      ? Flex(
                          direction: Axis.vertical,
                          children: [
                            for (PayloadCollection payload in state.payloads)
                              _buildItem(context, payload)
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
