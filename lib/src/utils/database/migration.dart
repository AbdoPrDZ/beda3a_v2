import 'dart:developer' as dev;

import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

import 'collection.dart';
import 'column.dart';

abstract class Migration<CollectionT extends Collection> {
  Database get database => Get.find();

  String get name;

  List<Column> get columns;

  String get query {
    String query = "CREATE TABLE $name (";
    for (var i = 0; i < columns.length; i++) {
      query += columns[i].query;
      if (i < columns.length - 1) query += ', ';
    }
    return "$query)";
  }

  Future migrate() async {
    dev.log(query);
    await database.execute(query);
    for (var collection in setupCollections()) {
      await collection;
    }
  }

  List<Future<CollectionT?>> setupCollections() => [];

  @override
  String toString() => name;
}
