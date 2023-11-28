import 'package:beda3a_v2/src/models/models.dart';
import 'package:get/get.dart';

import '../../services/main.service.dart';
import '../../src/consts/costs.dart';
import '../../src/utils/utils.dart';
import '../../src/views/views.dart';

class HomeController extends GetxController {
  MainService mainService = Get.find();

  UserCollection? user;

  PageController pageController = PageController();

  int currentTabIndex = 0;

  @override
  onInit() {
    mainService.realUser?.then((user) {
      this.user = user;
      update();
    });
    super.onInit();
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
