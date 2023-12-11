import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../src/src.dart';
import 'bloc/drivers_bloc.dart';

class DriversTab extends BlocPage<DriversBloc, DriversEvent, DriversState> {
  DriversTab({Key? key})
      : super(
          key: key,
          getBloc: (context) => DriversBloc(),
        );

  final searchController = TextEditController();

  @override
  Widget? buildFloatingActionButton(BuildContext context) =>
      BlocBuilder<DriversBloc, DriversState>(
        builder: (context, state) => Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 'create_driver',
              backgroundColor: UIThemeColors.iconBg,
              onPressed: () {
                callEvent(context, CreateDriverEvent());
              },
              child: const Icon(Icons.person_add_alt),
            ),
            const Gap(10),
            FloatingActionButton(
              heroTag: 'clear_drivers',
              backgroundColor: UIThemeColors.danger,
              onPressed: () {
                callEvent(context, ClearDriverEvent());
              },
              child: const Icon(Icons.clear_all),
            ),
          ],
        ),
      );

  Widget _buildItem(BuildContext context, DriverCollection driver) => InkWell(
        onTap: () => callEvent(context, EditDriverEvent(driver.id)),
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          child: Flex(
            direction: Axis.horizontal,
            children: [
              UserAvatarView.label(getNameSymbols(
                driver.fullName,
              )),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: driver.fullName,
                      style: TextStyle(
                        color: UIThemeColors.text2,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '\n${driver.createdAt}',
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
        child: BlocBuilder<DriversBloc, DriversState>(
          builder: (context, state) {
            if (state is DriversInitState) {
              callEvent(context, GetDriversEvent());
            }
            return Column(
              children: [
                TextEditView(
                  controller: searchController,
                  onSuffixPress: () {
                    callEvent(
                      context,
                      SearchDriversEvent(searchController.text),
                    );
                  },
                  suffixIcon: Icons.search,
                  hint: 'Type to search for driver...',
                ),
                SingleChildScrollView(
                  child: (state is DriversLoadedState)
                      ? Flex(
                          direction: Axis.vertical,
                          children: [
                            for (DriverCollection driver in state.drivers)
                              _buildItem(context, driver)
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
