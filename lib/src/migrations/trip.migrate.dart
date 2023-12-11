import '../utils/utils.dart';

class TripMigration extends Migration {
  @override
  String get name => 'trips';

  @override
  List<TableColumn> get columns => [
        TableColumn.index(),
        TableColumn.integer('truck_id'),
        TableColumn.string('from'),
        TableColumn.string('to'),
        TableColumn.double('distance').nullable(),
        TableColumn.dateTime('start_at').nullable(),
        TableColumn.dateTime('end_at').nullable(),
        TableColumn.text('details').setDefault('{}'),
        TableColumn.text('images').setDefault('[]'),
        TableColumn.dateTime('created_at').autoIncrement(),
      ];
}
