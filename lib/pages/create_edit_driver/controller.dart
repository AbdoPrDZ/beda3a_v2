import 'package:get/get.dart';

import '../../src/models/models.dart';
import '../../services/main.service.dart';
import '../../src/utils/utils.dart';
import '../../src/views/views.dart';

class CreateEditDriverController extends GetxController {
  MainService mainService = Get.find();

  CreateEditDriverData pageData = Get.arguments ?? const CreateEditDriverData();

  final formKey = GlobalKey<FormState>();
  Map<String, String> errors = {};

  DriverCollection? oldDriver;

  TextEditController firstNameController = TextEditController(
      // name: 'driver_first_name'
      text: 'Driver');
  TextEditController lastNameController = TextEditController(
      // name: 'driver_last_name'
      text: '1');
  TextEditController phoneController = TextEditController(
      // name: 'driver_phone'
      text: '+2130000001');
  TextEditController emailController = TextEditController(
      // name: 'driver_email'
      text: 'driver1@gmail.com');
  TextEditController addressController = TextEditController(
      // name: 'driver_address'
      );

  String gander = 'male';
  Map<String, String> details = {};

  @override
  void onInit() {
    if (pageData.action.isEdit) {
      DriverModel.find(pageData.driverId!).then((driver) async {
        oldDriver = driver;
        final driverUser = await driver!.user;
        firstNameController.text = driverUser.firstName;
        lastNameController.text = driverUser.lastName;
        phoneController.text = driverUser.phone;
        emailController.text = driverUser.email ?? '';
        addressController.text = driverUser.address ?? '';
        gander = driverUser.gender;
        update();
      });
    }
    super.onInit();
  }

  String? getFieldData(TextEditController controller) =>
      controller.text.trim().isNotEmpty ? controller.text.trim() : null;

  void create() async {
    if (formKey.currentState!.validate()) {
      DialogsView.loading().show();
      final result = await DriverModel.createWithUser(
        firstName: getFieldData(firstNameController)!,
        lastName: getFieldData(lastNameController)!,
        phone: getFieldData(phoneController)!,
        email: getFieldData(emailController),
        address: getFieldData(addressController),
        gender: gander,
        details: details,
      );
      Get.back();
      if (result.success) {
        formKey.currentState!.save();
        await DialogsView.message(
          'Create Driver',
          'Successfully creating driver',
        ).show();
        Get.back();
      } else {
        errors[result.fieldError!] = result.message!;
        formKey.currentState!.validate();
      }
    }
  }

  void edit() async {
    if (formKey.currentState!.validate() &&
        (await DialogsView.message(
              'Edit Driver #${oldDriver!.id}',
              'Are you sure you want to save changes?',
              actions: DialogAction.rYesNo,
            ).show() ??
            false)) {
      DialogsView.loading().show();
      final result = await oldDriver!.update(
        firstName: getFieldData(firstNameController)!,
        lastName: getFieldData(lastNameController)!,
        phone: getFieldData(phoneController)!,
        email: getFieldData(emailController),
        address: getFieldData(addressController),
        gender: gander,
        details: details,
      );
      if (result.success) {
        formKey.currentState!.save();
        Get.back();
        await DialogsView.message(
          'Edit Driver #${oldDriver!.id}',
          'Successfully editing driver',
        ).show();
      } else {
        errors[result.fieldError!] = result.message!;
        formKey.currentState!.validate();
      }
      Get.back();
    }
  }

  void delete() async {
    bool yes = await DialogsView.message(
          'Delete Driver #${oldDriver!.id}',
          'Are you sure you want to delete this driver?',
          actions: DialogAction.rYesNo,
        ).show() ??
        false;
    if (yes) {
      await oldDriver!.delete();
      await DialogsView.message(
        'Delete Driver #${oldDriver!.id}',
        'Successfully deleting driver',
      ).show();
      Get.back();
    }
  }
}

class CreateEditDriverData extends CreateEditPageData {
  final int? driverId;
  const CreateEditDriverData({super.action, super.data, this.driverId})
      : assert(
          !(action == CreateEditPageAction.edit && driverId == null),
          'Driver id is required when action is edit',
        );
}
