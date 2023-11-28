import 'package:get/get.dart';

import '../../../../src/consts/costs.dart';
import '../../../../src/utils/utils.dart' as utils;
import '../../../../src/views/views.dart';
import '../../../create_edit_driver/controller.dart';
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
  Widget buildBody(BuildContext context) => Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ButtonView.text(
            margin: const EdgeInsets.only(bottom: 5),
            backgroundColor: UIColors.success,
            onPressed: controller.createDriver,
            text: 'Create Driver',
          ),
          Expanded(
            child: Container(
              height: 200,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                color: UIThemeColors.cardBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: SingleChildScrollView(
                child: StreamBuilder(
                  stream: controller.drivers.stream,
                  builder: (context, snapshot) => Text(
                    'Drivers: ${snapshot.data ?? []}',
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
              onPressed: controller.driverId.value != -1
                  ? controller.editDriver
                  : null,
              text: 'Edit Drivers',
            ),
          ),
          ButtonView.text(
            margin: const EdgeInsets.only(top: 5),
            backgroundColor: UIColors.danger,
            onPressed: controller.clearDrivers,
            text: 'Clear Drivers',
          ),
        ],
      );
}
