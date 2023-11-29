import 'package:get/get.dart';

import '../../../../services/main.service.dart';
import '../../../../src/consts/costs.dart';
import '../../../../src/models/models.dart';
import '../../../../src/utils/utils.dart';
import '../../../create_edit_payload/controller.dart';

class PayloadsTabController extends GetxController {
  MainService mainService = Get.find();

  RxList<PayloadCollection> payloads = <PayloadCollection>[].obs;

  @override
  onInit() {
    getPayloads();
    super.onInit();
  }

  getPayloads() async {
    payloads.value = await PayloadModel.all();
    print(payloads);
    update();
  }

  createPayload() async {
    await RouteManager.to(PagesInfo.createEditPayload);
    getPayloads();
  }

  editPayload(int payloadId) async {
    await RouteManager.to(
      PagesInfo.createEditPayload,
      arguments: CreateEditPayloadData(
        action: CreateEditPageAction.edit,
        payloadId: payloadId,
      ),
    );
    getPayloads();
  }

  clearPayloads() async {
    await PayloadModel.clear();
    getPayloads();
  }
}
