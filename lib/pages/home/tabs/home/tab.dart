import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../src/src.dart';
import '../../controller.dart';
import 'bloc/home_bloc.dart';

class HomeTab extends BlocPage<HomeBloc, HomeEvent, HomeState> {
  final HomeController homeController;

  HomeTab({Key? key, required this.homeController})
      : super(getBloc: (context) => HomeBloc(), key: key);

  UserCollection? get user => homeController.user;

  @override
  Widget buildBody(BuildContext context) => Flex(
        direction: Axis.vertical,
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Home',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: UIThemeColors.text1,
              fontWeight: FontWeight.bold,
              fontSize: 50,
            ),
          ),
          BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              // if (state is HomeInitState) {
              //   callEvent(context, LoadTrucksHomeEvent());
              // }
              return DropDownView<int?>(
                value: homeController.selectedTruckId,
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('Select Truck'),
                  ),
                  for (TruckCollection truck in homeController.trucks.values)
                    DropdownMenuItem(
                      value: truck.id,
                      child: Text(truck.name),
                    ),
                ],
                onChanged: (value) {
                  if (homeController.selectedTruckId != value) {
                    homeController.selectTruck(value);
                  }
                },
              );
            },
          ),
          if (homeController.selectedTruckId != null)
            TripButtonView(truckId: homeController.selectedTruckId!),
          Column(
            children: [
              Text(
                'First name: ${user?.firstName}',
                style: TextStyle(color: UIThemeColors.text2),
              ),
              Text(
                'Last name: ${user?.lastName}',
                style: TextStyle(color: UIThemeColors.text2),
              ),
              Text(
                'Full name: ${user?.fullName}',
                style: TextStyle(color: UIThemeColors.text2),
              ),
              Text(
                'Email: ${user?.email}',
                style: TextStyle(color: UIThemeColors.text2),
              ),
            ],
          ),
        ],
      );
}
