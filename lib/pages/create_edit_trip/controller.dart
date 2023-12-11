import 'package:get/get.dart';

import '../../services/main.service.dart';
import '../../src/src.dart';

class CreateEditTripController extends GetxController {
  MainService mainService = Get.find();

  CreateEditTripData pageData = Get.arguments;

  final formKey = GlobalKey<FormState>();

  TripCollection? oldTrip;

  Map<String, String> errors = {};

  TextEditController fromController = TextEditController(
      //  name: 'trip_from'
      );
  TextEditController toController = TextEditController(
      // name: 'trip_to'
      );
  TextEditController distanceController = TextEditController(
    // name: 'trip_distance',
    text: '0',
  );
  TextEditController startAtController = TextEditController(
      //  name: 'trip_start_at'
      );
  TextEditController endAtController = TextEditController(
      //  name: 'trip_end_at'
      );
  List<OrderCollection> orders = [];
  List<OrderCollection> oldOrders = [];
  List<OrderCollection> createdOrders = [];
  List<OrderCollection> deletedOrders = [];
  // List<ExpensesCollection> expenses = [];
  Map<String, String> details = {};

  @override
  void onInit() {
    if (pageData.action.isEdit) {
      TripModel.find(pageData.tripId!).then((trip) async {
        oldTrip = trip;
        fromController.text = oldTrip!.from;
        toController.text = oldTrip!.to;
        distanceController.text = '${oldTrip!.distance}';
        startAtController.text = oldTrip!.startAt?.toString() ?? '';
        endAtController.text = oldTrip!.endAt?.toString() ?? '';
        orders = await oldTrip!.orders;
        oldOrders = orders;
        // expenses = await oldTrip!.expenses;
        details = oldTrip!.details;
        update();
      });
    } else {
      // TripModel.nextId(pageData.truckId!)
      //     .then((tripId) => this.tripId = tripId);
    }
    super.onInit();
  }

  void addOrder(OrderCollection order) {
    createdOrders.add(order);
    orders.add(order);
    update();
  }

  void removeOrder(OrderCollection order) {
    if (oldOrders.contains(order)) {
      deletedOrders.add(order);
      orders.remove(order);
    }
    update();
  }

  String? getFieldData(TextEditController controller) =>
      controller.text.trim().isNotEmpty ? controller.text.trim() : null;

  MDateTime? getFieldMDateTime(TextEditController controller) =>
      MDateTime.fromString(controller.text);

  void create() async {
    if (formKey.currentState!.validate()) {
      DialogsView.loading().show();

      final result = await TripModel.create(
        // tripId: tripId!,
        truckId: pageData.truckId!,
        from: getFieldData(fromController)!,
        to: getFieldData(toController)!,
        distance: double.tryParse(distanceController.text),
        startAt: getFieldMDateTime(startAtController),
        endAt: getFieldMDateTime(endAtController),
        // expenses: expenses,
        details: details,
      );
      if (result.success) {
        formKey.currentState!.save();
        for (OrderCollection order in createdOrders) {
          order.tripId = result.result!.id;
          await OrderModel.createFromMap(order.dataWithClients);
        }
        await (await TruckModel.find(pageData.truckId!))!
            .setCurrentTrip(result.result!);
        Get.back();
        await DialogsView.message(
          'Create Trip',
          'Successfully creating trip',
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
              'Edit Trip #${oldTrip!.id}',
              'Are you sure you want to save changes?',
              actions: DialogAction.rYesNo,
            ).show() ??
            false)) {
      DialogsView.loading().show();

      for (OrderCollection order in createdOrders) {
        order.tripId = oldTrip!.id;
        await OrderModel.createFromMap(order.dataWithClients);
      }

      for (OrderCollection order in deletedOrders) {
        await order.delete();
      }

      final result = await oldTrip!.update(
        from: getFieldData(fromController)!,
        to: getFieldData(toController)!,
        distance: double.tryParse(distanceController.text),
        startAt: getFieldMDateTime(startAtController),
        endAt: getFieldMDateTime(endAtController),
        // expensesIds: [for (ExpensesModel expense in expenses) expense.id],
        details: details,
      );
      if (result.success) {
        formKey.currentState!.save();
        Get.back();
        await DialogsView.message(
          'Edit Trip',
          'Successfully editing trip',
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
          'Delete Trip #${oldTrip!.id}',
          'Are you sure you want to delete this payload?',
          actions: DialogAction.rYesNo,
        ).show() ??
        false) {
      await oldTrip!.delete();
      await DialogsView.message(
        'Delete Trip #${oldTrip!.id}',
        'Successfully deleting payload',
      ).show();
      Get.back();
    }
  }
}

class CreateEditTripData extends CreateEditPageData {
  final int? truckId;
  final int? tripId;

  const CreateEditTripData({
    this.truckId,
    this.tripId,
    super.action,
    super.data,
  });
}
