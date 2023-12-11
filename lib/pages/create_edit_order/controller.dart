import 'package:get/get.dart';

import '../../services/main.service.dart';
import '../../src/src.dart';

class CreateEditOrderController extends GetxController {
  MainService mainService = Get.find();

  CreateEditOrderData pageData = Get.arguments ?? const CreateEditOrderData();

  final formKey = GlobalKey<FormState>();

  Map<String, String> errors = {};

  Map<int, ClientCollection> clients = {};
  int? fromClientId, toClientId;
  List<OrderPayloadCollection> payloads = [];

  Map<String, String> details = {};

  @override
  void onInit() {
    getClients();
    super.onInit();
  }

  Future getClients() async {
    clients = {for (var client in await ClientModel.all()) client.id: client};
    update();
  }

  void create() async {
    if (formKey.currentState!.validate()) {
      DialogsView.loading().show();
      // final result = await OrderModel.create(
      //   tripId: pageData.tripId,
      //   fromClientId: fromClientId!,
      //   toClientId: toClientId!,
      //   details: details,
      //   // payloads: payloads,
      //   // save: false,
      // );
      OrderCollection order = OrderCollection(
        null,
        pageData.tripId,
        clients[fromClientId!]!,
        clients[toClientId!]!,
        details,
        [],
        MDateTime.now,
        // payloads: payloads,
        // save: false,
      );
      Get.back();
      // if (result.success) {
      formKey.currentState!.save();
      await DialogsView.message(
        'Create Order',
        'Successfully creating order',
      ).show();
      // Get.back(result: result.result);
      Get.back(result: order);
      // } else {
      //   errors[result.fieldError!] = result.message!;
      //   formKey.currentState!.validate();
      // }
    }
  }

  void edit() async {}

  void delete() async {}
}

class CreateEditOrderData extends CreateEditPageData {
  final int? tripId;
  final int? orderId;

  const CreateEditOrderData({
    this.tripId,
    this.orderId,
    super.action,
    super.data,
  });
}
