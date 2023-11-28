import 'dart:developer' as dev;

import 'package:sqflite/sqflite.dart';

import 'collection.dart';
import 'column.dart';
import 'migration.dart';
import 'where_query/where_query.dart';

export 'where_query/where_query.dart';

abstract class Model {
  Column get index => Column.index();

  Migration get migration;

  List<String> get colsNames => [
        for (Column col in migration.columns) col.name,
      ];

  Database get database => migration.database;

  Future<int?> insert(Map<String, dynamic> data) {
    String query = 'INSERT INTO `$migration` (';
    for (var i = 0; i < data.length; i++) {
      String key = data.keys.elementAt(i);
      if (data[key] != null) {
        query += '\n  `$key`';
        if (i < data.length - 1) query += ', ';
      }
    }
    query += '\n)\nVALUES (';

    for (var i = 0; i < data.length; i++) {
      String key = data.keys.elementAt(i);
      if (data[key] != null) {
        query +=
            '\n  ${data[key] is String ? "'${data[key]}'" : '${data[key]}'}';
        if (i < data.length - 1) query += ', ';
      }
    }

    query += '\n)';

    dev.log('query: \n$query');
    return database.transaction((transaction) => transaction.rawInsert(query));
  }

  Future<List<Map<String, dynamic>>> where({
    List<String> columns = const [],
    WhereQuery? where,
    int? limit,
  }) async {
    String query = 'SELECT ';

    if (columns.isNotEmpty) {
      for (var i = 0; i < columns.length; i++) {
        query += '`${columns[i]}`';
        if (i < columns.length - 1) query += ', ';
      }
      query += '\n';
    } else {
      query += '* ';
    }

    query += 'FROM `$migration`';
    if (where != null) query += '\n$where';

    if (limit != null) query += '\nLIMIT $limit';

    dev.log('query: \n$query');
    return database.rawQuery(query);
  }

  Future<int> updateWhere(Map<String, dynamic> data, {WhereQuery? where}) {
    String query = 'UPDATE `$migration` SET ';

    for (var i = 0; i < data.length; i++) {
      String key = data.keys.elementAt(i);
      dynamic value = data[key];

      query +=
          '\n  `$key` = ${value == null ? 'NULL' : value is String ? "'$value'" : '$value'}';

      if (i < data.length - 1) query += ', ';
    }

    if (where != null) query += '\n$where';

    dev.log('query: \n$query');
    return database.rawUpdate(query);
  }

  Future<int> updateRow(dynamic id, Map<String, dynamic> data) => updateWhere(
        data,
        where: WhereQuery.fromWhereQueryItems([
          WhereQueryItem(
            column: '$index',
            condition: WhereQueryCondition.equals,
            value: id,
          ),
        ]),
      );

  Future<int> deleteWhere({WhereQuery? where}) {
    String query = 'DELETE FROM `$migration`';
    if (where != null) query += '\n$where';
    dev.log('query: \n$query');
    return database.rawDelete(query);
  }

  Future<int> deleteRow(dynamic id) => deleteWhere(
          where: WhereQuery.fromWhereQueryItems([
        WhereQueryItem(
          column: '$index',
          condition: WhereQueryCondition.equals,
          value: id,
        ),
      ]));

  Future<List<Collection?>> allRows({int? limit}) async => [
        for (final item in await where(limit: limit)) Collection(item),
      ];

  Future<Collection?> findRow(dynamic id) async {
    final result = await where(
      where: WhereQuery.fromWhereQueryItems(
        [
          WhereQueryItem(
            column: '$index',
            condition: WhereQueryCondition.equals,
            value: id,
          ),
        ],
      ),
      limit: 1,
    );
    return result.isNotEmpty
        ? Collection(Map<String, dynamic>.from(result.first))
        : null;
  }

  Future<int?> createRow(Collection collection) => insert(collection.data);
}
