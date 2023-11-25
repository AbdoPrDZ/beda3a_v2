import '../utils/utils.dart';

class DriverMigration extends Migration {
  @override
  String get name => 'drivers';

  @override
  List<Column> get columns => [
        Column.index(),
        Column.integer('user_id'),
        // Column.string('username'),
        Column.text('details').setDefault('{}'),
        Column.text('images').setDefault('[]'),
        Column.dateTime('created_at').autoIncrement(),
      ];
}
