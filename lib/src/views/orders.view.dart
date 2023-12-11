import 'package:gap/gap.dart';

import '../src.dart';

class OrdersView extends StatelessWidget {
  final String label;
  final bool readOnly;
  final double itemsBoxHeight;
  final List<OrderCollection> orders;
  final Function()? addOrder;
  final Function(OrderCollection order)? removeOrder;

  const OrdersView({
    super.key,
    this.label = 'Orders',
    this.readOnly = false,
    this.itemsBoxHeight = 250,
    required this.orders,
    this.addOrder,
    this.removeOrder,
  });

  @override
  Widget build(BuildContext context) {
    return FormField(
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
                    onPressed: addOrder,
                    size: 40,
                  ),
                ]
              ],
            ),
          ),
          buildBody: (context) => Flex(
            direction: Axis.vertical,
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
                    for (OrderCollection order in orders)
                      // FutureBuilder(
                      //   future: order.loadAll(),
                      //   builder: (context, snapshot) =>
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
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
                            CircleAvatar(
                              backgroundColor: UIThemeColors.iconBg,
                              child: Text(
                                getNameSymbols('${order.fromClient.fullName} '
                                    '${order.toClient.fullName}'),
                                style: TextStyle(
                                  color: UIThemeColors.iconFg1,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Flexible(
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'From: ',
                                      style: TextStyle(
                                        color: UIThemeColors.text2,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '${order.fromClient.fullName}\n',
                                    ),
                                    TextSpan(
                                      text: 'To: ',
                                      style: TextStyle(
                                        color: UIThemeColors.text2,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '${order.toClient.fullName}\n',
                                    ),
                                    TextSpan(
                                      text: 'Payloads count: ',
                                      style: TextStyle(
                                        color: UIThemeColors.text2,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: '\${order.payloads.length}',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            OutlineButtonView.icon(
                              Icons.delete,
                              onPressed: () => removeOrder?.call(order),
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
