import '../utils/utils.dart';

class DriverMigration extends Migration {
  @override
  String get name => 'drivers';

  @override
  List<TableColumn> get columns => [
        TableColumn.index(),
        TableColumn.integer('user_id'),
        // Column.string('username'),
        TableColumn.text('details').setDefault('{}'),
        TableColumn.text('images').setDefault('[]'),
        TableColumn.dateTime('created_at').autoIncrement(),
      ];
}
