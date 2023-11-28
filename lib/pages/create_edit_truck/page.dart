import 'package:gap/gap.dart';

import '../../src/consts/ui_theme.dart';
import '../../src/models/models.dart';
import '../../src/utils/utils.dart' as utils;
import '../../src/views/views.dart';
import 'controller.dart';

class CreateEditTruckPage extends utils.Page<CreateEditTruckController> {
  static const String name = '/create_edit_truck';

  CreateEditTruckPage({Key? key})
      : super(controller: CreateEditTruckController(), key: key);

  @override
  CreateEditTruckController get controller => super.controller!;

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => AppBar(
        backgroundColor: UIThemeColors.primary,
        title: Text('${controller.pageData.action} Truck'),
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
                    '${controller.pageData.action} Truck',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: UIThemeColors.text1,
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                    ),
                  ),
                ),
                TextEditView(
                  controller: controller.nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Truck name is required";
                    }
                    return null;
                  },
                  label: 'Truck name',
                ),
                // Flex(
                //   direction: Axis.horizontal,
                //   children: [
                //     Flexible(
                //       child: DropDownView<DriverId?>(
                //         value: controller.driverId,
                //         label: 'Current Driver',
                //         items: [
                //           const DropdownMenuItem(
                //             value: null,
                //             child: Text('None'),
                //           ),
                //           for (DriverModel driver in controller.drivers)
                //             DropdownMenuItem(
                //               value: driver.id,
                //               child: Text(driver.fullName),
                //             ),
                //         ],
                //         onChanged: (value) {
                //           controller.driverId = value;
                //           controller.update();
                //         },
                //       ),
                //     ),
                //     OutlineButtonView.icon(
                //       Icons.add,
                //       margin: const EdgeInsets.only(top: 30),
                //       onPressed: () async {
                //         await RouteManager.to(PagesInfo.createEditDriver);
                //         controller.getDrivers();
                //       },
                //       size: 35,
                //     ),
                //     if (controller.driverId != null) ...[
                //       const Gap(5),
                //       OutlineButtonView.icon(
                //         Icons.edit,
                //         margin: const EdgeInsets.only(top: 30),
                //         onPressed: () async {
                //           await RouteManager.to(
                //             PagesInfo.createEditDriver,
                //             arguments: CreateEditDriverData(
                //               action: CreateEditPageAction.edit,
                //               driverId: controller.driverId,
                //             ),
                //           );
                //           controller.getDrivers();
                //         },
                //         size: 35,
                //         iconColor: UIColors.warning,
                //         borderColor: UIColors.warning,
                //       ),
                //     ]
                //   ],
                // ),

                // ExpensesView(
                //   expenses: controller.expenses,
                //   addExpenses: () async {
                //     final expenses = await RouteManager.to(
                //       PagesInfo.createEditExpenses,
                //       arguments: CreateEditExpensesData(
                //         save: false,
                //         truckId: controller.truckId,
                //       ),
                //     );
                //     if (expenses != null) controller.expenses.add(expenses);
                //     controller.update();
                //   },
                //   removeExpenses: (expenses) {
                //     controller.expenses.remove(expenses);
                //     controller.update();
                //   },
                // ),
                DetailsView(
                  details: controller.details,
                  // sessionsName: 'truck-${controller.pageData.action}',
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
