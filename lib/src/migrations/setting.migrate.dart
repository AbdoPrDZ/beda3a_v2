import '../models/models.dart';
import '../utils/utils.dart';

class SettingMigration extends Migration<SettingCollection> {
  @override
  String get name => 'settings';

  @override
  List<Column> get columns => [
        Column.string('name').primary(),
        Column.text('value').nullable(),
        Column.dateTime('created_at').autoIncrement(),
      ];

  @override
  List<Future<SettingCollection?>> setupCollections() => [
        SettingModel.create<String>(name: 'theme', value: 'light'),
        SettingModel.create<String>(name: 'language', value: 'en'),
        SettingModel.create<Map>(name: 'user', value: {
          'user_id': null,
          'is_auth': false,
          'password': null,
        }),
      ];
}
