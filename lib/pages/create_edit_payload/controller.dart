import 'package:get/get.dart';

import '../../services/main.service.dart';
import '../../src/src.dart';

class CreateEditPayloadController extends GetxController {
  MainService mainService = Get.find();

  CreateEditPayloadData pageData =
      Get.arguments ?? const CreateEditPayloadData();

  final formKey = GlobalKey<FormState>();

  PayloadCollection? oldPayload;

  Map<String, String> errors = {};

  TextEditController nameController = TextEditController(
      // name: 'payload_name'
      );
  TextEditController categoryController = TextEditController(
      // name: 'payload_category',
      );
  TextEditController descriptionController = TextEditController(
      // name: 'payload_description',
      );
  Map<String, PayloadAddress> addresses = {};
  Map<String, String> details = {};

  @override
  void onInit() {
    if (pageData.action.isEdit) {
      PayloadModel.find(pageData.payloadId!).then((payload) {
        oldPayload = payload!;
        nameController.text = payload.name;
        categoryController.text = payload.category;
        addresses = payload.addresses;
        details = payload.details;
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
      final result = await PayloadModel.create(
        name: getFieldData(nameController)!,
        category: getFieldData(categoryController)!,
        description: getFieldData(descriptionController),
        addresses: addresses,
        details: details,
      );
      if (result.success) {
        formKey.currentState!.save();
        Get.back();
        await DialogsView.message(
          'Create Payload',
          'Successfully creating payload',
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
              'Edit Payload #${oldPayload!.id}',
              'Are you sure you want to save changes?',
              actions: DialogAction.rYesNo,
            ).show() ??
            false)) {
      DialogsView.loading().show();
      final result = await oldPayload!.update(
        name: getFieldData(nameController)!,
        category: getFieldData(categoryController)!,
        description: getFieldData(descriptionController),
        addresses: addresses,
        details: details,
      );
      if (result.success) {
        formKey.currentState!.save();
        Get.back();
        await DialogsView.message(
          'Edit Payload #${oldPayload!.id}',
          'Successfully editing payload',
        ).show();
      } else {
        errors[result.fieldError!] = result.message!;
        formKey.currentState!.validate();
      }
      Get.back();
    }
  }

  void delete() async {
    if (await DialogsView.message(
          'Delete Payload #${oldPayload!.id}',
          'Are you sure you want to delete this payload?',
          actions: DialogAction.rYesNo,
        ).show() ??
        false) {
      await oldPayload!.delete();
      await DialogsView.message(
        'Delete Payload #${oldPayload!.id}',
        'Successfully deleting payload',
      ).show();
      Get.back();
    }
  }
}

class CreateEditPayloadData extends CreateEditPageData {
  final int? payloadId;

  const CreateEditPayloadData({super.action, this.payloadId}) : super();
}
