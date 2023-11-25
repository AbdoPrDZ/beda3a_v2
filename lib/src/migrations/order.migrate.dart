import '../utils/utils.dart';

class OrderMigration extends Migration {
  @override
  String get name => 'orders';

  @override
  List<Column> get columns => [
        Column.index(),
        Column.integer('from_client_id'),
        Column.integer('to_client_id'),
        Column.text('details').setDefault('{}'),
        Column.text('images').setDefault('[]'),
        Column.dateTime('created_at').autoIncrement(),
      ];
}
