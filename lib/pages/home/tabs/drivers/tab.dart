import 'package:gap/gap.dart';

import '../../../../src/consts/costs.dart';
import '../../../../src/models/models.dart';
import '../../../../src/utils/utils.dart' as utils;
import '../../../../src/views/views.dart';
import 'controller.dart';

class DriversTab extends utils.Page<DriversTabController> {
  DriversTab({Key? key}) : super(controller: DriversTabController(), key: key);

  @override
  DriversTabController get controller => super.controller!;

  // static Widget floatingActionButton(BuildContext context) =>
  //     FloatingActionButton(
  //       backgroundColor: UIThemeColors.iconBg,
  //       onPressed: () => utils.RouteManager.to(PagesInfo.createEditDriver),
  //       child: const Icon(Icons.person_add_alt),
  //     );

  @override
  Widget? buildFloatingActionButton(BuildContext context) => Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'create_driver',
            backgroundColor: UIThemeColors.iconBg,
            onPressed: controller.createDriver,
            child: const Icon(Icons.person_add_alt),
          ),
          const Gap(10),
          FloatingActionButton(
            heroTag: 'clear_drivers',
            backgroundColor: UIThemeColors.danger,
            onPressed: controller.clearDrivers,
            child: const Icon(Icons.clear_all),
          ),
        ],
      );

  Widget _buildItem(BuildContext context, DriverCollection driver) => InkWell(
        onTap: () => controller.editDriver(driver.id),
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          child: FutureBuilder<UserCollection>(
            future: driver.user,
            builder: (context, snapshot) => Flex(
              direction: Axis.horizontal,
              children: [
                UserAvatarView.label(utils.getNameSymbols(
                  snapshot.data?.fullName ?? 'D${driver.id}',
                )),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: snapshot.data?.fullName ?? 'D${driver.id}',
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
        ),
      );

  @override
  Widget buildBody(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: SingleChildScrollView(
          child: StreamBuilder<List<DriverCollection>>(
            stream: controller.drivers.stream,
            builder: (context, snapshot) => Flex(
              direction: Axis.vertical,
              children: [
                for (DriverCollection driver in snapshot.data ?? [])
                  _buildItem(context, driver)
              ],
            ),
          ),
        ),
      );
}
