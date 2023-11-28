import 'package:get/get.dart';

import '../../../../src/consts/costs.dart';
import '../../../../src/utils/utils.dart' as utils;
import '../../../../src/views/views.dart';
import '../../../create_edit_truck/controller.dart';
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
  Widget buildBody(BuildContext context) => Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ButtonView.text(
            margin: const EdgeInsets.only(bottom: 5),
            backgroundColor: UIColors.success,
            onPressed: controller.createTruck,
            text: 'Create Truck',
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                color: UIThemeColors.cardBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: SingleChildScrollView(
                child: StreamBuilder(
                  stream: controller.trucks.stream,
                  builder: (context, snapshot) => Text(
                    'Trucks: ${snapshot.data ?? []}',
                    style: TextStyle(
                      color: UIThemeColors.text2,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Obx(
            () => ButtonView.text(
              margin: const EdgeInsets.only(top: 5),
              backgroundColor: UIColors.warning,
              onPressed:
                  controller.truckId.value != -1 ? controller.editTruck : null,
              text: 'Edit Trucks',
            ),
          ),
          ButtonView.text(
            margin: const EdgeInsets.only(top: 5),
            backgroundColor: UIColors.danger,
            onPressed: controller.clearTrucks,
            text: 'Clear Trucks',
          ),
        ],
      );
}
