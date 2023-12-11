import '../utils/utils.dart';

class PayloadMigration extends Migration {
  @override
  String get name => 'payloads';

  @override
  List<TableColumn> get columns => [
        TableColumn.index(),
        TableColumn.string('name'),
        TableColumn.string('category'),
        TableColumn.text('description'),
        TableColumn.text('addresses').setDefault('{}'),
        TableColumn.text('details').setDefault('{}'),
        TableColumn.text('images').setDefault('[]'),
        TableColumn.dateTime('created_at').autoIncrement(),
      ];
}
