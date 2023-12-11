import 'package:get/get.dart';

import '../../services/main.service.dart';
import '../../src/src.dart';

class HomeController extends GetxController {
  MainService mainService = Get.find();

  UserCollection? get user => mainService.realUser;

  PageController pageController = PageController();

  int currentTabIndex = 0;

  int? selectedTruckId;
  Map<int, TruckCollection> trucks = {};

  @override
  void onReady() {
    getTrucks();
    super.onReady();
  }

  getTrucks() async {
    trucks = {
      for (TruckCollection truck in await TruckModel.all()) truck.id: truck
    };
    if (!trucks.containsKey(selectedTruckId)) selectedTruckId = null;
    update();
  }

  selectTruck(int? id) {
    selectedTruckId = id;
    update();
  }

  Future logout() async {
    bool logout = await DialogsView.message(
          'Logout',
          'Are sure you want to logout?',
          actions: DialogAction.rYesCancel,
        ).show() ??
        false;
    if (logout) {
      mainService.logout();
      RouteManager.to(PagesInfo.login, clearHeaders: true);
    }
  }
}
