import 'package:get/get.dart';

import '../../services/main.service.dart';
import '../../src/src.dart';

class CreateEditClientController extends GetxController {
  MainService mainService = Get.find();

  CreateEditClientData pageData = Get.arguments ?? const CreateEditClientData();

  final formKey = GlobalKey<FormState>();

  ClientCollection? oldClient;

  Map<String, String> errors = {};

  TextEditController firstNameController = TextEditController(
      // name: 'client_first_name'
      );
  TextEditController lastNameController = TextEditController(
      // name: 'client_last_name'
      );
  TextEditController phoneController = TextEditController(
      // name: 'client_phone'
      );
  TextEditController emailController = TextEditController(
      // name: 'client_email'
      );
  TextEditController companyController = TextEditController(
      // name: 'client_company'
      );
  TextEditController addressController = TextEditController(
      // name: 'client_address'
      );

  String gender = 'male';
  Map<String, String> details = {};

  @override
  void onInit() {
    if (pageData.action.isEdit) {
      ClientModel.find(pageData.clientId!).then((client) {
        oldClient = client!;
        firstNameController.text = client.firstName;
        lastNameController.text = client.lastName;
        phoneController.text = client.phone;
        emailController.text = client.email ?? '';
        companyController.text = client.company ?? '';
        addressController.text = client.address ?? '';
        gender = client.gender;
        details = client.details;
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
      final result = await ClientModel.createWithUser(
        firstName: getFieldData(firstNameController)!,
        lastName: getFieldData(lastNameController)!,
        phone: getFieldData(phoneController)!,
        email: getFieldData(emailController),
        company: getFieldData(companyController),
        address: getFieldData(addressController),
        gender: gender,
        details: details,
      );
      if (result.success) {
        formKey.currentState!.save();
        Get.back();
        await DialogsView.message(
          'Create Client',
          'Successfully creating client',
        ).show();
      } else {
        errors[result.fieldError!] = result.message!;
        formKey.currentState!.validate();
      }
      Get.back();
    }
  }

  void edit() async {
    if (formKey.currentState!.validate() &&
        (await DialogsView.message(
              'Edit Client #${oldClient!.id}',
              'Are you sure you want to save changes?',
              actions: DialogAction.rYesNo,
            ).show() ??
            false)) {
      DialogsView.loading().show();
      final result = await oldClient!.update(
        firstName: getFieldData(firstNameController)!,
        lastName: getFieldData(lastNameController)!,
        phone: getFieldData(phoneController)!,
        email: getFieldData(emailController),
        company: getFieldData(companyController),
        address: getFieldData(addressController),
        gender: gender,
        details: details,
      );
      if (result.success) {
        formKey.currentState!.save();
        Get.back();
        await DialogsView.message(
          'Edit Client #${oldClient!.id}',
          'Successfully editing client',
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
          'Delete Client #${oldClient!.id}',
          'Are you sure you want to delete this client?',
          actions: DialogAction.rYesNo,
        ).show() ??
        false;
    if (yes) {
      await oldClient!.delete();
      await DialogsView.message(
        'Delete Client #${oldClient!.id}',
        'Successfully deleting client',
      ).show();
      Get.back();
    }
  }
}

class CreateEditClientData extends CreateEditPageData {
  final int? clientId;

  const CreateEditClientData({super.action, this.clientId}) : super();
}
