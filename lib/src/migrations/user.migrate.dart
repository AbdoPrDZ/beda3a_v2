import '../models/models.dart';
import '../utils/utils.dart';

class UserMigration extends Migration<UserCollection> {
  @override
  String get name => 'users';

  @override
  List<TableColumn> get columns => [
        TableColumn.index(),
        TableColumn.string('first_name'),
        TableColumn.string('last_name'),
        TableColumn.string('phone').setLength(20),
        TableColumn.string('email').setLength(50).nullable(),
        TableColumn.string('address').setLength(50).nullable(),
        TableColumn.string('company').setLength(50).nullable(),
        TableColumn.check('gender', ['male', 'female']).setDefault('male'),
        TableColumn.text('details').setDefault('{}'),
        TableColumn.text('images').setDefault('[]'),
        TableColumn.dateTime('created_at').autoIncrement(),
      ];

  // @override
  // List<Future<UserCollection?>> setupCollections() => [
  //       for (var item in Fakes.fakeUsers) UserModel.createFromMap(item),
  //     ];
}
