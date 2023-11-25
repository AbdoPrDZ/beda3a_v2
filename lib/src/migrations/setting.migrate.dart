import '../models/models.dart';
import '../utils/utils.dart';

class SettingMigration extends Migration<SettingCollection> {
  @override
  String get name => 'settings';

  @override
  List<Column> get columns => [
        Column.index(),
        Column.string('name'),
        Column.text('value').nullable(),
        Column.dateTime('created_at').autoIncrement(),
      ];

  @override
  List<Future<SettingCollection?>> setupCollections() => [
        SettingModel.create(name: 'theme', value: 'light'),
        SettingModel.create(name: 'language', value: 'en'),
        SettingModel.create(name: 'user_id'),
      ];
}
