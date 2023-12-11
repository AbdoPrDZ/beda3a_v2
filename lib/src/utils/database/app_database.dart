import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

import 'migration.dart';

export 'migration.dart';
export 'table_column.dart';
export 'column_type.dart';
export 'model.dart';
export 'collection.dart';

class AppDatabase {
  final String source;
  final List<Migration> migrations;

  Database get database => Get.find();

  const AppDatabase(this.source, this.migrations);

  Future init({bool deleteIt = false}) async {
    if (deleteIt) await deleteDatabase(source);
    Get.put(await openDatabase(
      source,
      version: 1,
      onCreate: (database, v) async {
        Get.put(database);
        for (var migration in migrations) {
          await migration.migrate();
        }
      },
    ));
  }
}
