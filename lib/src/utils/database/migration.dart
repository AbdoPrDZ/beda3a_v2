import 'dart:developer' as dev;

import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

import 'collection.dart';
import 'table_column.dart';

abstract class Migration<CollectionT extends Collection> {
  Database get database => Get.find();

  String get name;

  List<TableColumn> get columns;

  String get query => 'CREATE TABLE `$name` (${columns.map(
        (column) => column.query,
      ).join(', ')})';

  Future migrate() async {
    dev.log('query: \n$query');
    await database.execute(query);
    for (var collection in setupCollections) {
      await collection;
    }
  }

  List<Future<CollectionT?>> get setupCollections => [];

  @override
  String toString() => name;
}
