import '../utils/utils.dart';

class OrderPayloadMigration extends Migration {
  @override
  String get name => 'order_payloads';

  @override
  List<TableColumn> get columns => [
        TableColumn.index(),
        TableColumn.integer('payload_id'),
        TableColumn.integer('count'),
        TableColumn.string('selected_address').nullable(),
        TableColumn.dateTime('charging_date').nullable(),
        TableColumn.string('charging_address').nullable(),
        TableColumn.dateTime('discharging_date').nullable(),
        TableColumn.string('discharging_address').nullable(),
        TableColumn.double('cost'),
        TableColumn.double('price'),
        TableColumn.check('getting_cost_type', ['value', 'count']),
        TableColumn.double('total_cost'),
        TableColumn.check('getting_price_type', ['value', 'count']),
        TableColumn.double('total_price'),
        TableColumn.check(
            'getting_general_price_type', ['only_cost', 'with_price']),
        TableColumn.double('general_price'),
        TableColumn.text('details').setDefault('{}'),
        TableColumn.text('images').setDefault('[]'),
        TableColumn.dateTime('created_at').autoIncrement(),
      ];
}
