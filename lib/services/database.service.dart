import 'dart:developer' as dev;

import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

import '../src/consts/fakes.dart';
import '../src/migrations/migrations.dart';
import '../src/models/models.dart';
import '../src/utils/database/migration.dart';
import '../src/utils/utils.dart';

class DatabaseService extends GetxService {
  AppDatabase? appDatabase;

  Database? database;

  List<Migration> get migrations => [
        UserMigration(),
        ClientMigration(),
        DriverMigration(),
        TruckMigration(),
        TripMigration(),
        PayloadMigration(),
        ExpenseMigration(),
        OrderMigration(),
        OrderPayloadMigration(),
        MiniPayloadMigration(),
        SettingMigration(),
      ];

  initDatabase() async {
    if (database != null) {
      throw Exception("The database is already initialized");
    }
    // String databasesPath = await getDatabasesPath();
    // await deleteDatabase('$databasesPath/source.db');
    // database = await openDatabase(
    //   '$databasesPath/source.db',
    //   version: 1,
    //   onCreate: (db, v) {
    //     Get.put(db);

    //     for (var migration in migrations) {
    //       migration.migrate();
    //     }
    //   },
    // );

    // database = await openDatabase('C:/Users/abdo_pr/Documents/source.db');

    String databasesPath = await getDatabasesPath();
    appDatabase = AppDatabase('$databasesPath/source.db', migrations);
  }

  showDatabases() async =>
      dev.log('${await database?.rawQuery('PRAGMA database_list;')}');

  showTables() async => dev.log('${await database?.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%';",
      )}');

  insertUser() async => [
        for (var i = 0; i < Fakes.fakeUsers.length; i++)
          dev.log('${await UserModel.createFromMap(Fakes.fakeUsers[i])}')
      ];

  all() async => dev.log('${await UserModel.all()}');

  find() async => dev.log('${await UserModel.find(2)}');

  update() async {
    UserCollection? user = await UserModel.find(2);

    dev.log('updae: ${await user?.update(
      firstName: 'Abdo',
      lastName: 'Pr',
    )}, ${await UserModel.find(2)}');
  }

  @override
  void onClose() {
    database?.close();
    super.onClose();
  }
}
