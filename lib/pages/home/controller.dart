import 'package:beda3a_v2/src/models/models.dart';
import 'package:get/get.dart';

import '../../services/main.service.dart';

class HomeController extends GetxController {
  MainService mainService = Get.find();

  UserCollection? user;

  @override
  onInit() {
    mainService.realUser?.then((user) {
      this.user = user;
      update();
    });
    super.onInit();
  }

  logout() {
    mainService.logout();
  }
}
