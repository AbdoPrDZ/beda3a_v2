import '../utils/utils.dart';

class OrderMigration extends Migration {
  @override
  String get name => 'orders';

  @override
  List<TableColumn> get columns => [
        TableColumn.index(),
        TableColumn.integer('trip_id'),
        TableColumn.integer('from_client_id'),
        TableColumn.integer('to_client_id'),
        TableColumn.text('details').setDefault('{}'),
        TableColumn.text('images').setDefault('[]'),
        TableColumn.dateTime('created_at').autoIncrement(),
      ];
}
