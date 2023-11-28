import '../utils/utils.dart';

class TruckMigration extends Migration {
  @override
  String get name => 'trucks';

  @override
  List<Column> get columns => [
        Column.index(),
        Column.string('name'),
        Column.integer('driver_id').nullable(),
        Column.text('details').setDefault('{}'),
        Column.text('images').setDefault('[]'),
        Column.dateTime('created_at').autoIncrement(),
      ];
}
