import 'package:get/get.dart';

import '../../../../services/main.service.dart';
import '../../../../src/consts/costs.dart';
import '../../../../src/models/models.dart';
import '../../../../src/utils/utils.dart';
import '../../../create_edit_driver/controller.dart';

class DriversTabController extends GetxController {
  MainService mainService = Get.find();

  RxList<DriverCollection> drivers = <DriverCollection>[].obs;

  Rx<int> driverId = (-1).obs;

  @override
  onInit() {
    getDrivers();
    super.onInit();
  }

  getDrivers() async {
    drivers.value = await DriverModel.all();
    print(drivers);
    if (drivers.isNotEmpty) {
      driverId.value = drivers.first.id;
    } else {
      driverId.value = -1;
    }
    update();
  }

  createDriver() async {
    await RouteManager.to(PagesInfo.createEditDriver);
    getDrivers();
  }

  editDriver() async {
    await RouteManager.to(
      PagesInfo.createEditDriver,
      arguments: CreateEditDriverData(
        action: CreateEditPageAction.edit,
        driverId: driverId.value!,
      ),
    );
    getDrivers();
  }

  clearDrivers() async {
    await DriverModel.clear();
    getDrivers();
  }
}
