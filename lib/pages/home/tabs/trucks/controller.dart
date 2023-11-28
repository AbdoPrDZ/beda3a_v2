import 'package:get/get.dart';

import '../../../../services/main.service.dart';
import '../../../../src/consts/costs.dart';
import '../../../../src/models/models.dart';
import '../../../../src/utils/utils.dart';
import '../../../create_edit_truck/controller.dart';

class TrucksTabController extends GetxController {
  MainService mainService = Get.find();

  RxList<TruckCollection> trucks = <TruckCollection>[].obs;
  Rx<int> truckId = (-1).obs;

  @override
  onInit() {
    getTrucks();
    super.onInit();
  }

  getTrucks() async {
    trucks.value = await TruckModel.all();
    print(trucks);
    if (trucks.isNotEmpty) {
      truckId.value = trucks.first.id;
    } else {
      truckId.value = -1;
    }
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
        truckId: truckId.value!,
      ),
    );
    getTrucks();
  }

  clearTrucks() async {
    await TruckModel.clear();
    getTrucks();
  }
}
