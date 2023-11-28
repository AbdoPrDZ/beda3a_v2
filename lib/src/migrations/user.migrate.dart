import '../models/models.dart';
import '../utils/utils.dart';

class UserMigration extends Migration<UserCollection> {
  @override
  String get name => 'users';

  @override
  List<Column> get columns => [
        Column.index(),
        Column.string('first_name'),
        Column.string('last_name'),
        Column.string('phone').setLength(20),
        Column.string('email').setLength(50).nullable(),
        Column.string('address').setLength(50).nullable(),
        Column.string('company').setLength(50).nullable(),
        Column.check('gender', ['male', 'female']).setDefault('male'),
        Column.text('details').setDefault('{}'),
        Column.text('images').setDefault('[]'),
        Column.dateTime('created_at').autoIncrement(),
      ];

  // @override
  // List<Future<UserCollection?>> setupCollections() => [
  //       for (var item in Fakes.fakeUsers) UserModel.createFromMap(item),
  //     ];
}
