import 'package:get/get.dart';

import '../../../../services/main.service.dart';
import '../../../../src/consts/costs.dart';
import '../../../../src/models/models.dart';
import '../../../../src/utils/utils.dart';
import '../../../create_edit_truck/controller.dart';

class HomeTabController extends GetxController {
  MainService mainService = Get.find();

  RxList<TruckCollection> trucks = <TruckCollection>[].obs;

  @override
  onInit() {
    getTrucks();
    super.onInit();
  }

  getTrucks() async {
    trucks.value = await TruckModel.all();
    print(trucks);
    update();
  }

  createTruck() async {
    await RouteManager.to(PagesInfo.createEditTruck);
    getTrucks();
  }

  editTruck() async {
    await RouteManager.to(
      PagesInfo.createEditTruck,
      arguments: CreateEditTruckData(
        action: CreateEditPageAction.edit,
        truckId: trucks.first.id,
      ),
    );
    getTrucks();
  }

  clearTrucks() async {
    await TruckModel.clear();
    getTrucks();
  }
}
