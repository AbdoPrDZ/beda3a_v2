import 'package:gap/gap.dart';

import '../../../../src/consts/costs.dart';
import '../../../../src/models/models.dart';
import '../../../../src/utils/utils.dart' as utils;
import '../../../../src/views/views.dart';
import 'controller.dart';

class PayloadsTab extends utils.Page<PayloadsTabController> {
  PayloadsTab({Key? key})
      : super(controller: PayloadsTabController(), key: key);

  @override
  PayloadsTabController get controller => super.controller!;

  // static Widget floatingActionButton(BuildContext context) =>
  //     FloatingActionButton(
  //       backgroundColor: UIThemeColors.iconBg,
  //       onPressed: () => utils.RouteManager.to(PagesInfo.createEditPayload),
  //       child: const Icon(Icons.apps),
  //     );

  @override
  Widget? buildFloatingActionButton(BuildContext context) => Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'create_payload',
            backgroundColor: UIThemeColors.iconBg,
            onPressed: controller.createPayload,
            child: const Icon(Icons.apps),
          ),
          const Gap(10),
          FloatingActionButton(
            heroTag: 'clear_payloads',
            backgroundColor: UIThemeColors.danger,
            onPressed: controller.clearPayloads,
            child: const Icon(Icons.clear_all),
          ),
        ],
      );

  Widget _buildItem(BuildContext context, PayloadCollection payload) => InkWell(
        onTap: () => controller.editPayload(payload.id),
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          child: Flex(
            direction: Axis.horizontal,
            children: [
              UserAvatarView.label(utils.getNameSymbols(
                payload.name,
              )),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: payload.name,
                      style: TextStyle(
                        color: UIThemeColors.text2,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '\n${payload.createdAt}',
                      style: TextStyle(
                        color: UIThemeColors.text3,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  @override
  Widget buildBody(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: SingleChildScrollView(
          child: StreamBuilder<List<PayloadCollection>>(
            stream: controller.payloads.stream,
            builder: (context, snapshot) => Flex(
              direction: Axis.vertical,
              children: [
                for (PayloadCollection payload in snapshot.data ?? [])
                  _buildItem(context, payload)
              ],
            ),
          ),
        ),
      );
}
