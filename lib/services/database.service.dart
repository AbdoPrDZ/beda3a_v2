import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

import '../src/migrations/migrations.dart';
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
    String databasesPath = await getDatabasesPath();
    appDatabase = AppDatabase('$databasesPath/source.db', migrations);
    await appDatabase!.init(deleteIt: false);
    database = appDatabase!.database;
  }

  @override
  void onClose() {
    database?.close();
    super.onClose();
  }
}
