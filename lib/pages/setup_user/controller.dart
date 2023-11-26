import 'package:get/get.dart';

import '../../services/main.service.dart';
import '../../src/consts/pages_info.dart';
import '../../src/models/models.dart';
import '../../src/utils/utils.dart';
import '../../src/views/views.dart';

class SetupUserController extends GetxController {
  MainService mainService = Get.find();

  final formKey = GlobalKey<FormState>();

  Map<String, String> errors = {};

  late TextEditController firstNameController;
  late TextEditController lastNameController;
  late TextEditController emailController;
  late TextEditController phoneController;
  late TextEditController companyController;
  late TextEditController addressController;
  late TextEditController passwordController;
  late TextEditController confirmController;

  String gender = 'male';

  @override
  onInit() {
    firstNameController =
        TextEditController(name: 'first_name', text: 'Abderrahmane');
    lastNameController =
        TextEditController(name: 'last_name', text: 'Guerguer');
    emailController =
        TextEditController(name: 'email', text: 'abdopr47@gmail.com');
    phoneController = TextEditController(name: 'phone', text: '+213778185797');
    companyController = TextEditController(name: 'company', text: 'Abdo Pr');
    addressController = TextEditController(name: 'address');
    passwordController = TextEditController(text: '123456');
    confirmController = TextEditController(text: '123456');
    super.onInit();
  }

  String? getFieldData(TextEditController controller) =>
      controller.text.trim().isNotEmpty ? controller.text.trim() : null;

  setup() async {
    if (formKey.currentState!.validate()) {
      DialogsView.loading().show();
      UserCollection user = (await UserModel.create(
        firstName: getFieldData(firstNameController)!,
        lastName: getFieldData(lastNameController)!,
        phone: getFieldData(phoneController)!,
        email: getFieldData(emailController),
        address: getFieldData(addressController),
        company: getFieldData(companyController),
        gender: gender,
      ))!;

      try {
        await mainService.setupUser(user.id, passwordController.text);
        formKey.currentState!.save();

        Get.back();
        await DialogsView.message(
          'Setup User',
          'User created successfully',
        ).show();
        RouteManager.to(PagesInfo.home, clearHeaders: true);
      } catch (e) {
        Get.back();
        await DialogsView.message('Setup User', '$e').show();
      }
    }
  }
}
