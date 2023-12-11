import '../utils/utils.dart';

class TruckMigration extends Migration {
  @override
  String get name => 'trucks';

  @override
  List<TableColumn> get columns => [
        TableColumn.index(),
        TableColumn.string('name'),
        TableColumn.integer('driver_id').nullable(),
        TableColumn.integer('current_trip_id').nullable(),
        TableColumn.text('details').setDefault('{}'),
        TableColumn.text('images').setDefault('[]'),
        TableColumn.dateTime('created_at').autoIncrement(),
      ];
}
