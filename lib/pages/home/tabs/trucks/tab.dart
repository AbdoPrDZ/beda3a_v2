import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../src/src.dart';
import '../../controller.dart';
import 'bloc/trucks_bloc.dart';

class TrucksTab extends BlocPage<TrucksBloc, TrucksEvent, TrucksState> {
  TrucksTab({Key? key, required HomeController homeController})
      : super(
          key: key,
          getBloc: (context) => TrucksBloc(homeController),
        );

  final searchController = TextEditController();

  @override
  Widget? buildFloatingActionButton(BuildContext context) =>
      BlocBuilder<TrucksBloc, TrucksState>(
        builder: (context, state) => Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 'create_truck',
              backgroundColor: UIThemeColors.iconBg,
              onPressed: () {
                callEvent(context, CreateTruckEvent());
              },
              child: const Icon(Icons.fire_truck_outlined),
            ),
            const Gap(10),
            FloatingActionButton(
              heroTag: 'clear_trucks',
              backgroundColor: UIThemeColors.danger,
              onPressed: () {
                callEvent(context, ClearTruckEvent());
              },
              child: const Icon(Icons.clear_all),
            ),
          ],
        ),
      );

  Widget _buildItem(BuildContext context, TruckCollection truck) => InkWell(
        onTap: () => callEvent(context, EditTruckEvent(truck.id)),
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          child: Flex(
            direction: Axis.horizontal,
            children: [
              UserAvatarView.label(getNameSymbols(
                truck.name,
              )),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: truck.name,
                      style: TextStyle(
                        color: UIThemeColors.text2,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '\n${truck.createdAt}',
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
        child: BlocBuilder<TrucksBloc, TrucksState>(
          builder: (context, state) {
            if (state is TrucksInitState) {
              callEvent(context, GetTrucksEvent());
            }
            return Column(
              children: [
                TextEditView(
                  controller: searchController,
                  onSuffixPress: () {
                    callEvent(
                      context,
                      SearchTrucksEvent(searchController.text),
                    );
                  },
                  suffixIcon: Icons.search,
                  hint: 'Type to search for truck...',
                ),
                SingleChildScrollView(
                  child: (state is TrucksLoadedState)
                      ? Flex(
                          direction: Axis.vertical,
                          children: [
                            for (TruckCollection truck in state.trucks)
                              _buildItem(context, truck)
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
