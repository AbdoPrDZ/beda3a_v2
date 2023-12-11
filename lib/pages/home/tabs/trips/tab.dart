import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../src/src.dart';
import 'bloc/trips_bloc.dart';

class TripsTab extends BlocPage<TripsBloc, TripsEvent, TripsState> {
  final int? truckId;

  TripsTab({Key? key, this.truckId})
      : super(
          key: key,
          getBloc: (context) => TripsBloc(),
        );

  final searchController = TextEditController();

  @override
  Widget? buildFloatingActionButton(BuildContext context) =>
      BlocBuilder<TripsBloc, TripsState>(
        builder: (context, state) => Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (truckId != null)
              FloatingActionButton(
                heroTag: 'create_trip',
                backgroundColor: UIThemeColors.iconBg,
                onPressed: () {
                  callEvent(context, CreateTripEvent(truckId!));
                },
                child: const Icon(Icons.alt_route_sharp),
              ),
            const Gap(10),
            FloatingActionButton(
              heroTag: 'clear_trips',
              backgroundColor: UIThemeColors.danger,
              onPressed: () {
                callEvent(context, ClearTripEvent());
              },
              child: const Icon(Icons.clear_all),
            ),
          ],
        ),
      );

  Widget _buildItem(BuildContext context, TripCollection trip) => InkWell(
        onTap: () => callEvent(context, EditTripEvent(trip.id)),
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          child: Flex(
            direction: Axis.horizontal,
            children: [
              UserAvatarView.label(getNameSymbols(
                '${trip.from} ${trip.to}',
              )),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${trip.from} ${trip.to}',
                      style: TextStyle(
                        color: UIThemeColors.text2,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '\n${trip.createdAt}',
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
        child: BlocBuilder<TripsBloc, TripsState>(
          builder: (context, state) {
            if (state is TripsInitState) {
              callEvent(context, GetTripsEvent());
            }
            return Column(
              children: [
                TextEditView(
                  controller: searchController,
                  onSuffixPress: () {
                    callEvent(
                      context,
                      SearchTripsEvent(searchController.text),
                    );
                  },
                  suffixIcon: Icons.search,
                  hint: 'Type to search for trip...',
                ),
                SingleChildScrollView(
                  child: (state is TripsLoadedState)
                      ? Flex(
                          direction: Axis.vertical,
                          children: [
                            for (TripCollection trip in state.trips)
                              _buildItem(context, trip)
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
