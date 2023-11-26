import 'package:get/get.dart';

import '../../services/main.service.dart';
import '../../src/consts/pages_info.dart';
import '../../src/utils/utils.dart';
import '../../src/views/views.dart';

class LoginController extends GetxController {
  MainService mainService = Get.find();

  final formKey = GlobalKey<FormState>();

  Map<String, String> errors = {};

  late TextEditController emailPhoneController;
  late TextEditController passwordController;

  @override
  onInit() {
    emailPhoneController = TextEditController(name: 'email, phone');
    passwordController = TextEditController();
    super.onInit();
  }

  login() async {
    if (emailPhoneController.text != mainService.realUser!.email &&
        emailPhoneController.text != mainService.realUser!.phone) {
      errors['email_phone'] = 'Invalid email or phone';
    } else if (passwordController.text != mainService.userSetting!.password) {
      // } else if (Password.verify(
      //   passwordController.text,
      //   mainService.realUser!.password,
      // )) {
      errors['password'] = 'Invalid password';
    }

    if (formKey.currentState!.validate()) {
      DialogsView.loading().show();
      await mainService.onAuth();
      formKey.currentState!.save();
      Get.back();
      await DialogsView.message('Login', 'Successfully login').show();
      RouteManager.to(PagesInfo.home, clearHeaders: true);
    }
  }
}
