import '../utils/utils.dart';

class MiniPayloadMigration extends Migration {
  @override
  String get name => 'mini_payloads';

  @override
  List<Column> get columns => [
        Column.index(),
        Column.string('name'),
        Column.string('receiver_name'),
        Column.string('receiver_phone'),
        Column.double('cost'),
        Column.dateTime('charging_date').nullable(),
        Column.string('charging_address').nullable(),
        Column.dateTime('discharging_date').nullable(),
        Column.string('discharging_address').nullable(),
        Column.text('details').setDefault('{}'),
        Column.text('images').setDefault('[]'),
        Column.dateTime('created_at').autoIncrement(),
      ];
}
