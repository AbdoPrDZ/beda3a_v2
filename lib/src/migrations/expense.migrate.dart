import '../utils/utils.dart';

class ExpenseMigration extends Migration {
  @override
  String get name => 'expenses';

  @override
  List<Column> get columns => [
        Column.index(),
        Column.string('name'),
        Column.string('address'),
        Column.double('cost'),
        Column.text('details').setDefault('{}'),
        Column.text('images').setDefault('[]'),
        Column.dateTime('created_at').autoIncrement(),
      ];
}
