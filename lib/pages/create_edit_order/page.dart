import 'package:gap/gap.dart';

import '../../src/src.dart';
import '../create_edit_client/controller.dart';
import 'controller.dart';

class CreateEditOrderPage extends MPage<CreateEditOrderController> {
  static const String name = '/create_edit_order';

  CreateEditOrderPage({Key? key})
      : super(controller: CreateEditOrderController(), key: key);

  @override
  CreateEditOrderController get controller => super.controller!;

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => AppBar(
        backgroundColor: UIThemeColors.primary,
        title: Text('${controller.pageData.action} Order'),
      );

  @override
  Widget buildBody(BuildContext context) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
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
                    '${controller.pageData.action} Order',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: UIThemeColors.text1,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ),
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    Flexible(
                      child: DropDownView<int?>(
                        value: controller.fromClientId,
                        label: 'From Client',
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('From'),
                          ),
                          for (ClientCollection client
                              in controller.clients.values)
                            DropdownMenuItem(
                              value: client.id,
                              child: Text(client.fullName),
                            ),
                        ],
                        validation: (value) {
                          if (value == null) return 'Sender client is required';
                          return null;
                        },
                        onChanged: (value) {
                          if (value != null &&
                              value != controller.fromClientId) {
                            controller.fromClientId = value;
                            controller.update();
                          }
                        },
                      ),
                    ),
                    OutlineButtonView.icon(
                      Icons.add,
                      margin: const EdgeInsets.only(top: 30),
                      onPressed: () async {
                        await RouteManager.to(PagesInfo.createEditClient);
                        controller.getClients();
                      },
                      size: 35,
                    ),
                    if (controller.fromClientId != null) ...[
                      const Gap(5),
                      OutlineButtonView.icon(
                        Icons.edit,
                        margin: const EdgeInsets.only(top: 30),
                        onPressed: () async {
                          await RouteManager.to(
                            PagesInfo.createEditClient,
                            arguments: CreateEditClientData(
                              action: CreateEditPageAction.edit,
                              clientId: controller.fromClientId,
                            ),
                          );
                          controller.getClients();
                        },
                        size: 35,
                        iconColor: UIColors.warning,
                        borderColor: UIColors.warning,
                      ),
                    ]
                  ],
                ),
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    Flexible(
                      child: DropDownView<int?>(
                        value: controller.toClientId,
                        label: 'To Client',
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('To'),
                          ),
                          for (ClientCollection client
                              in controller.clients.values)
                            DropdownMenuItem(
                              value: client.id,
                              child: Text(client.fullName),
                            ),
                        ],
                        validation: (value) {
                          if (value == null) {
                            return 'Receiver client is required';
                          } else if (controller.fromClientId ==
                              controller.toClientId) {
                            return 'Sender and Receiver client must be not equals';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          if (value != null && value != controller.toClientId) {
                            controller.toClientId = value;
                            controller.update();
                          }
                        },
                      ),
                    ),
                    OutlineButtonView.icon(
                      Icons.add,
                      margin: const EdgeInsets.only(top: 30),
                      onPressed: () {
                        RouteManager.to(
                          PagesInfo.createEditClient,
                        );
                        controller.getClients();
                      },
                      size: 35,
                    ),
                    if (controller.toClientId != null) ...[
                      const Gap(5),
                      OutlineButtonView.icon(
                        Icons.edit,
                        margin: const EdgeInsets.only(top: 30),
                        onPressed: () {
                          RouteManager.to(
                            PagesInfo.createEditClient,
                            arguments: CreateEditClientData(
                              action: CreateEditPageAction.edit,
                              clientId: controller.toClientId,
                            ),
                          );
                          controller.getClients();
                        },
                        size: 35,
                        iconColor: UIColors.warning,
                        borderColor: UIColors.warning,
                      ),
                    ]
                  ],
                ),
                // OrderPayloadsView(
                //   label: 'Payloads',
                //   payloads: controller.payloads,
                //   addPayload: () async {
                //     final payload =
                //         await RouteManager.to(PagesInfo.createEditOrderPayload);
                //     if (payload != null) controller.payloads.add(payload);
                //     controller.update();
                //   },
                //   removePayload: (payload) {
                //     controller.payloads.remove(payload);
                //     controller.update();
                //   },
                //   validator: (value) {
                //     if (value?.isNotEmpty != true) {
                //       return 'Order Payloads is required';
                //     }
                //     return null;
                //   },
                // ),
                DetailsView(
                  details: controller.details,
                  // sessionsName: 'order-${controller.pageData.action}',
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
                const Gap(10),
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
