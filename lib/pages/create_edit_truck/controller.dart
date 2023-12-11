import 'package:get/get.dart';

import '../../services/main.service.dart';
import '../../src/src.dart';

class CreateEditTruckController extends GetxController {
  MainService mainService = Get.find();

  CreateEditTruckData pageData = Get.arguments ?? const CreateEditTruckData();

  final formKey = GlobalKey<FormState>();

  Map<String, String> errors = {};

  TruckCollection? oldTruck;

  int? truckId;
  TextEditController nameController = TextEditController(
      // name: 'truck_name'
      // text: 'Official Truck',
      );
  List<DriverCollection> drivers = [];
  int? driverId;
  // List<ExpensesModel> expenses = [];
  Map<String, String> details = {};

  Future getDrivers() async {
    drivers = await DriverModel.allWhere();
    // drivers = drivers.where((driver) => driver.currentTripId == null).toList();
    if (driverId != null &&
        ![
          for (var driver in drivers) driver.id,
        ].contains(driverId)) {
      driverId = null;
    }
  }

  @override
  void onInit() {
    if (pageData.action.isEdit) {
      TruckModel.find(pageData.truckId!).then((truck) async {
        await getDrivers();
        oldTruck = truck;
        truckId = truck!.id;
        nameController.text = truck.name;
        driverId = truck.driverId;
        // expenses = await truck.expenses;
        details = truck.details;
        update();
      });
    } else {
      getDrivers().then((value) => update());
      // TruckModel.nextId().then((truckId) => this.truckId = truckId);
    }
    super.onInit();
  }

  String? getFieldData(TextEditController controller) =>
      controller.text.trim().isNotEmpty ? controller.text.trim() : null;

  void create() async {
    if (formKey.currentState!.validate()) {
      DialogsView.loading().show();
      final result = await TruckModel.create(
        // truckId: truckId!,
        name: getFieldData(nameController)!,
        driverId: driverId,
        // expenses: expenses,
        details: details,
      );
      if (result.success) {
        formKey.currentState!.save();
        Get.back();
        await DialogsView.message(
          'Create Truck',
          'Successfully creating truck',
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
              'Edit Truck #${oldTruck!.id}',
              'Are you sure you want to save changes?',
              actions: DialogAction.rYesNo,
            ).show() ??
            false)) {
      DialogsView.loading().show();
      final result = await oldTruck!.update(
        name: getFieldData(nameController)!,
        driverId: driverId,
        // expenses: expenses,
        details: details,
      );
      if (result.success) {
        formKey.currentState!.save();
        Get.back();
        await DialogsView.message(
          'Edit Truck ${oldTruck!.id}',
          'Successfully editing truck',
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
          'Delete Truck #${oldTruck!.id}',
          'Are you sure you want to delete this truck?',
          actions: DialogAction.rYesNo,
        ).show() ??
        false;
    if (yes) {
      await oldTruck!.delete();
      await DialogsView.message(
        'Delete Truck #${oldTruck!.id}',
        'Successfully deleting truck',
      ).show();
      Get.back();
    }
  }
}

class CreateEditTruckData extends CreateEditPageData {
  final int? truckId;
  const CreateEditTruckData({super.action, this.truckId, super.data});
}
