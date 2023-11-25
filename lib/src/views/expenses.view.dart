import 'package:gap/gap.dart';

import '../consts/costs.dart';
import '../models/models.dart';
import '../utils/utils.dart';
import 'views.dart';

class ExpensesView extends StatelessWidget {
  final String label;
  final bool readOnly;
  final double itemsBoxHeight;
  final List<ExpenseCollection> expenses;
  final Function()? addExpenses;
  final Function(ExpenseCollection expenses)? removeExpenses;

  const ExpensesView({
    super.key,
    this.label = 'Expenses',
    this.readOnly = false,
    this.itemsBoxHeight = 250,
    required this.expenses,
    this.addExpenses,
    this.removeExpenses,
  });

  @override
  Widget build(BuildContext context) {
    return FormField(
      builder: (state) => ExpandedView(
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
                  onPressed: addExpenses,
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
                  for (ExpenseCollection expenses in expenses)
                    // FutureBuilder(
                    //   future: expenses.loadAll(),
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
                          Flex(
                            direction: Axis.horizontal,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor: UIThemeColors.iconBg,
                                child: Text(
                                  getNameSymbols(expenses.name),
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
                                      text: 'Name: ',
                                      style: TextStyle(
                                        color: UIThemeColors.text2,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '${expenses.name}\n',
                                      style: TextStyle(
                                        color: UIThemeColors.text3,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Cost: ',
                                      style: TextStyle(
                                        color: UIThemeColors.text2,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '${expenses.cost}\n',
                                      style: TextStyle(
                                        color: UIThemeColors.text3,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Address: ',
                                      style: TextStyle(
                                        color: UIThemeColors.text2,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: expenses.address,
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
                            onPressed: () => removeExpenses?.call(expenses),
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
      ),
    );
  }
}
