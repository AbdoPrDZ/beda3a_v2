import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../src/consts/costs.dart';
import '../../src/utils/utils.dart' as utils;
import '../../src/views/views.dart';
import 'controller.dart';

class CreateEditDriverPage extends utils.Page<CreateEditDriverController> {
  static const String name = '/create_edit_driver';

  CreateEditDriverPage({Key? key})
      : super(controller: CreateEditDriverController(), key: key);

  @override
  CreateEditDriverController get controller => super.controller!;

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => AppBar(
        backgroundColor: UIThemeColors.primary,
        title: Text(controller.pageData.action.isEdit
            ? 'Edit Driver #${controller.pageData.driverId}'
            : 'Create Driver'),
      );

  @override
  Widget buildBody(BuildContext context) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Form(
            key: controller.formKey,
            onChanged: () {
              if (controller.errors.isNotEmpty) controller.errors = {};
            },
            child: Flex(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    '${controller.pageData.action} Driver',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: UIThemeColors.text1,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ),
                TextEditView(
                  controller: controller.firstNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "First name is required";
                    } else if (controller.errors.containsKey('first_name')) {
                      return controller.errors['first_name'];
                    }
                    return null;
                  },
                  label: 'First name',
                ),
                TextEditView(
                  controller: controller.lastNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Last name is required";
                    } else if (controller.errors.containsKey('last_name')) {
                      return controller.errors['last_name'];
                    }
                    return null;
                  },
                  label: 'Last name',
                ),
                TextEditView(
                  controller: controller.phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Phone is required";
                    } else if (!value.isPhoneNumber) {
                      return "Please enter valid phone (+213000 00 00 00*)";
                    } else if (controller.errors.containsKey('phone')) {
                      return controller.errors['phone'];
                    }
                    return null;
                  },
                  label: 'Phone',
                ),
                TextEditView(
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value != null && value.isNotEmpty && !value.isEmail) {
                      return "Please enter valid email (example@mail.com)";
                    } else if (controller.errors.containsKey('email')) {
                      return controller.errors['email'];
                    }
                    return null;
                  },
                  label: 'Email',
                ),
                TextEditView(
                  controller: controller.addressController,
                  keyboardType: TextInputType.streetAddress,
                  label: 'Address',
                ),
                DropDownView(
                  value: controller.gander,
                  label: 'Gander',
                  items: const [
                    DropdownMenuItem(value: 'male', child: Text('Male')),
                    DropdownMenuItem(value: 'female', child: Text('Female')),
                  ],
                  onChanged: (value) {
                    if (value != null && value != controller.gander) {
                      controller.gander = value;
                      controller.update();
                    }
                  },
                ),
                DetailsView(
                  details: controller.details,
                  // sessionsName: 'driver-${controller.pageData.action}',
                  onAdd: (name, value) {
                    controller.details[name] = value;
                    controller.update();
                    return controller.details;
                  },
                  onRemove: (name) {
                    controller.details.remove(name);
                    controller.update();
                    return controller.details;
                  },
                ),
                const Gap(15),
                if (controller.pageData.action.isEdit) ...[
                  ButtonView.text(
                    backgroundColor: UIColors.warning,
                    onPressed: controller.edit,
                    text: 'Edit',
                  ),
                  ButtonView.text(
                    backgroundColor: UIThemeColors.danger,
                    onPressed: controller.delete,
                    text: 'Delete',
                  ),
                ] else
                  ButtonView.text(
                    onPressed: controller.create,
                    text: 'Create',
                  )
              ],
            ),
          ),
        ),
      );
}
