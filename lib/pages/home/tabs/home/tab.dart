import 'package:beda3a_v2/src/utils/route_manager.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../src/consts/costs.dart';
import '../../../../src/models/models.dart';
import '../../../../src/utils/utils.dart' as utils;
import '../../../../src/views/views.dart';
import '../../controller.dart';
import 'controller.dart';

class HomeTab extends utils.Page<HomeTabController> {
  final HomeController homeController;
  HomeTab({Key? key, required this.homeController})
      : super(controller: HomeTabController(), key: key);

  @override
  HomeTabController get controller => super.controller!;

  UserCollection? get user => homeController.user;

  @override
  Widget buildBody(BuildContext context) => Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
          // DropDownView<TruckId?>(
          //   value: homeController.selectedTruckId,
          //   items: [
          //     const DropdownMenuItem(value: null, child: Text('Select Truck')),
          //     for (TruckModel truck in homeController.trucks)
          //       DropdownMenuItem(value: truck.id, child: Text(truck.name)),
          //   ],
          //   onChanged: (value) {
          //     homeController.selectedTruckId = value;
          //     homeController.update();
          //   },
          // ),
          const Gap(20),
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
