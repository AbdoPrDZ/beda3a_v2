import 'package:get/get.dart';

import '../../../../services/main.service.dart';
import '../../../../src/consts/costs.dart';
import '../../../../src/models/models.dart';
import '../../../../src/utils/utils.dart';
import '../../../create_edit_driver/controller.dart';

class DriversTabController extends GetxController {
  MainService mainService = Get.find();

  RxList<DriverCollection> drivers = <DriverCollection>[].obs;

  @override
  onInit() {
    getDrivers();
    super.onInit();
  }

  getDrivers() async {
    drivers.value = await DriverModel.all();
    print(drivers);
    update();
  }

  createDriver() async {
    await RouteManager.to(PagesInfo.createEditDriver);
    getDrivers();
  }

  editDriver(int driverId) async {
    await RouteManager.to(
      PagesInfo.createEditDriver,
      arguments: CreateEditDriverData(
        action: CreateEditPageAction.edit,
        driverId: driverId,
      ),
    );
    getDrivers();
  }

  clearDrivers() async {
    await DriverModel.clear();
    getDrivers();
  }
}
