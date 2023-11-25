import '../utils/utils.dart';

class PayloadMigration extends Migration {
  @override
  String get name => 'payloads';

  @override
  List<Column> get columns => [
        Column.index(),
        Column.string('name'),
        Column.string('category'),
        Column.text('description'),
        Column.text('addresses').setDefault('{}'),
        Column.text('details').setDefault('{}'),
        Column.text('images').setDefault('[]'),
        Column.dateTime('created_at').autoIncrement(),
      ];
}
