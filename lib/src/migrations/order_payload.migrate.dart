import '../utils/utils.dart';

class OrderPayloadMigration extends Migration {
  @override
  String get name => 'order_payloads';

  @override
  List<Column> get columns => [
        Column.index(),
        Column.integer('payload_id'),
        Column.integer('count'),
        Column.string('selected_address').nullable(),
        Column.dateTime('charging_date').nullable(),
        Column.string('charging_address').nullable(),
        Column.dateTime('discharging_date').nullable(),
        Column.string('discharging_address').nullable(),
        Column.double('cost'),
        Column.double('price'),
        Column.check('getting_cost_type', ['value', 'count']),
        Column.double('total_cost'),
        Column.check('getting_price_type', ['value', 'count']),
        Column.double('total_price'),
        Column.check('getting_general_price_type', ['only_cost', 'with_price']),
        Column.double('general_price'),
        Column.text('details').setDefault('{}'),
        Column.text('images').setDefault('[]'),
        Column.dateTime('created_at').autoIncrement(),
      ];
}
