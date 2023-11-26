import 'package:get/get.dart';

import '../../services/main.service.dart';
import '../../src/utils/utils.dart';

class LoadingController extends GetxController {
  MainService mainService = Get.find();

  @override
  void onReady() {
    loading();
    super.onReady();
  }

  void loading() {
    RouteManager.to(mainService.next(), clearHeaders: true);
  }
}
