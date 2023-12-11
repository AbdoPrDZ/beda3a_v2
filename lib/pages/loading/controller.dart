import 'package:get/get.dart';

import '../../services/main.service.dart';
import '../../src/src.dart';

class LoadingController extends GetxController {
  MainService mainService = Get.find();

  @override
  void onReady() {
    loading();
    super.onReady();
  }

  void loading() async {
    await Future.delayed(const Duration(seconds: 2));
    RouteManager.to(await mainService.next(), clearHeaders: true);
  }
}
