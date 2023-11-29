import 'package:gap/gap.dart';

import '../../../../src/consts/costs.dart';
import '../../../../src/models/models.dart';
import '../../../../src/utils/utils.dart' as utils;
import '../../../../src/views/views.dart';
import 'controller.dart';

class TrucksTab extends utils.Page<TrucksTabController> {
  TrucksTab({Key? key}) : super(controller: TrucksTabController(), key: key);

  @override
  TrucksTabController get controller => super.controller!;

  // static Widget floatingActionButton(BuildContext context) =>
  //     FloatingActionButton(
  //       backgroundColor: UIThemeColors.iconBg,
  //       onPressed: () => utils.RouteManager.to(PagesInfo.createEditTruck),
  //       child: const Icon(Icons.fire_truck),
  //     );

  @override
  Widget? buildFloatingActionButton(BuildContext context) => Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'create_truck',
            backgroundColor: UIThemeColors.iconBg,
            onPressed: controller.createTruck,
            child: const Icon(Icons.fire_truck),
          ),
          const Gap(10),
          FloatingActionButton(
            heroTag: 'clear_trucks',
            backgroundColor: UIThemeColors.danger,
            onPressed: controller.clearTrucks,
            child: const Icon(Icons.clear_all),
          ),
        ],
      );

  Widget _buildItem(BuildContext context, TruckCollection truck) => InkWell(
        onTap: () => controller.editTruck(truck.id),
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          child: Flex(
            direction: Axis.horizontal,
            children: [
              UserAvatarView.label(utils.getNameSymbols(
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
        child: SingleChildScrollView(
          child: StreamBuilder<List<TruckCollection>>(
            stream: controller.trucks.stream,
            builder: (context, snapshot) => Flex(
              direction: Axis.vertical,
              children: [
                for (TruckCollection truck in snapshot.data ?? [])
                  _buildItem(context, truck)
              ],
            ),
          ),
        ),
      );
}
