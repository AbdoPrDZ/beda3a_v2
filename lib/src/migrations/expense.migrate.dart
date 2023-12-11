import '../utils/utils.dart';

class ExpenseMigration extends Migration {
  @override
  String get name => 'expenses';

  @override
  List<TableColumn> get columns => [
        TableColumn.index(),
        TableColumn.string('name'),
        TableColumn.string('address'),
        TableColumn.double('cost'),
        TableColumn.text('details').setDefault('{}'),
        TableColumn.text('images').setDefault('[]'),
        TableColumn.dateTime('created_at').autoIncrement(),
      ];
}
