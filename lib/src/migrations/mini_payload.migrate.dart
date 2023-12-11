import '../utils/utils.dart';

class MiniPayloadMigration extends Migration {
  @override
  String get name => 'mini_payloads';

  @override
  List<TableColumn> get columns => [
        TableColumn.index(),
        TableColumn.string('name'),
        TableColumn.string('receiver_name'),
        TableColumn.string('receiver_phone'),
        TableColumn.double('cost'),
        TableColumn.dateTime('charging_date').nullable(),
        TableColumn.string('charging_address').nullable(),
        TableColumn.dateTime('discharging_date').nullable(),
        TableColumn.string('discharging_address').nullable(),
        TableColumn.text('details').setDefault('{}'),
        TableColumn.text('images').setDefault('[]'),
        TableColumn.dateTime('created_at').autoIncrement(),
      ];
}
