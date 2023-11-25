import 'package:gap/gap.dart';

import '../consts/costs.dart';
import '../models/models.dart';
import '../utils/utils.dart';
import 'views.dart';

class OrderPayloadsView extends StatelessWidget {
  final String label;
  final bool readOnly;
  final double itemsBoxHeight;
  final List<OrderPayloadCollection> payloads;
  final Function()? addPayload;
  final Function(OrderPayloadCollection order)? removePayload;
  final String? Function(List<OrderPayloadCollection>?)? validator;

  const OrderPayloadsView({
    super.key,
    this.label = 'Order Payloads',
    this.readOnly = false,
    this.itemsBoxHeight = 250,
    required this.payloads,
    this.addPayload,
    this.removePayload,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return FormField<List<OrderPayloadCollection>>(
      initialValue: payloads,
      validator: validator,
      builder: (state) {
        return ExpandedView(
          headerPadding: const EdgeInsets.symmetric(vertical: 10),
          buildHeader: (context) => Flexible(
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: UIThemeColors.text2,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (!readOnly) ...[
                  const Spacer(),
                  OutlineButtonView.icon(
                    Icons.add,
                    onPressed: addPayload,
                    size: 40,
                  ),
                ]
              ],
            ),
          ),
          buildBody: (context) => Flex(
            direction: Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: itemsBoxHeight,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: UIThemeColors.fieldBg,
                  border: Border.all(
                    width: 0.8,
                    color: state.hasError
                        ? UIThemeColors.fieldDanger
                        : UIThemeColors.field,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView(
                  primary: false,
                  children: [
                    for (OrderPayloadCollection payload in payloads)
                      // FutureBuilder(
                      //   future: payload.loadAll(),
                      //   builder: (context, snapshot) =>
                      Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                          color: UIThemeColors.fieldBg,
                          border: Border.all(
                            width: 0.5,
                            color: UIThemeColors.field,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Flex(
                          direction: Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flex(
                              direction: Axis.horizontal,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: UIThemeColors.iconBg,
                                  child: Text(
                                    '\${payload.payload_ != null ? getNameSymbols(payload.payload_!.name) : payload.payloadId}',
                                    style: TextStyle(
                                      color: UIThemeColors.iconFg1,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const Gap(8),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Payload: ',
                                        style: TextStyle(
                                          color: UIThemeColors.text2,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            '\${payload.payload_?.name ?? payload.payloadId}\n',
                                        style: TextStyle(
                                          color: UIThemeColors.text3,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Count: ',
                                        style: TextStyle(
                                          color: UIThemeColors.text2,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '\${payload.count}\n',
                                        style: TextStyle(
                                          color: UIThemeColors.text3,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Value: ',
                                        style: TextStyle(
                                          color: UIThemeColors.text2,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '\${payload.value}\n',
                                        style: TextStyle(
                                          color: UIThemeColors.text3,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'General Price: ',
                                        style: TextStyle(
                                          color: UIThemeColors.text2,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '\${payload.generalPrice} DZD',
                                        style: TextStyle(
                                          color: UIThemeColors.text3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            OutlineButtonView.icon(
                              Icons.delete,
                              onPressed: () => removePayload?.call(payload),
                              size: 30,
                              borderColor: Colors.transparent,
                              iconColor: UIThemeColors.danger,
                            ),
                          ],
                        ),
                      ),
                    // )
                  ],
                ),
              ),
              if (state.hasError) ...[
                const Gap(4),
                Text.rich(
                  TextSpan(
                    children: [
                      WidgetSpan(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Icon(
                            Icons.error_outline,
                            color: UIThemeColors.fieldDanger,
                            size: 15,
                          ),
                        ),
                      ),
                      TextSpan(text: state.errorText!),
                    ],
                  ),
                  style: TextStyle(color: UIThemeColors.fieldDanger),
                )
              ]
            ],
          ),
        );
      },
    );
  }
}
