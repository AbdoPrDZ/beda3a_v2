import '../utils/utils.dart';

class TripMigration extends Migration {
  @override
  String get name => 'trips';

  @override
  List<Column> get columns => [
        Column.index(),
        Column.string('from'),
        Column.string('to'),
        Column.double('distance'),
        Column.dateTime('start_at').nullable(),
        Column.dateTime('end_at').nullable(),
        Column.text('details').setDefault('{}'),
        Column.text('images').setDefault('[]'),
        Column.dateTime('created_at').autoIncrement(),
      ];
}
