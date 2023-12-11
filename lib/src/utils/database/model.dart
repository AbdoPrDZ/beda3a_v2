import 'dart:developer' as dev;

import 'package:sqflite/sqflite.dart';

import 'collection.dart';
import 'table_column.dart';
import 'migration.dart';
import 'where_query/where_query.dart';

export 'where_query/where_query.dart';

abstract class Model {
  String get index => '$migration.${TableColumn.index().name}';

  Migration get migration;

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

    dev.log('insert-query: \n$query');
    return database.transaction((transaction) => transaction.rawInsert(query));
  }

  Future<List<Map<String, dynamic>>> select({
    List<String> columns = const [],
    List<SelectJoin> selectJoins = const [],
    WhereQuery? where,
    int? limit,
  }) async {
    String query = 'SELECT';

    if (columns.isNotEmpty) {
      query += '\n  `$migration`.`${columns.join('`,\n  `$migration`.`')}`';
    } else {
      if (selectJoins.isNotEmpty) query += '\n ';
      query += ' `$migration`.*';
      if (selectJoins.isEmpty) query += ' ';
    }

    if (selectJoins.isNotEmpty) {
      query += ',\n  ${[
        for (final selectJoin in selectJoins) selectJoin.columnStr,
      ].join(',\n  ')}\n';
    } else if (columns.isNotEmpty) {
      query += '\n';
    }

    query += 'FROM `$migration`';

    for (final selectJoin in selectJoins) {
      if (selectJoins.length != 1) query += '\n ';
      query += ' LEFT JOIN ${selectJoin.migrationName}';
      if (selectJoin.where != null) query += ' ${selectJoin.where}';
    }

    if (where != null) query += '\n$where';

    if (limit != null) query += '\nLIMIT $limit';

    dev.log('select-query: \n$query');
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

    dev.log('update-query: \n$query');
    return database.rawUpdate(query);
  }

  Future<int> updateRow(dynamic id, Map<String, dynamic> data) => updateWhere(
        data,
        where: WhereQuery(items: [
          WhereQueryItemCondition(
            column: index,
            condition: WhereQueryCondition.equals,
            value: id,
          ),
        ]),
      );

  Future<int> deleteWhere({WhereQuery? where}) {
    String query = 'DELETE FROM `$migration`';
    if (where != null) query += '\n$where';
    dev.log('delete-query: \n$query');
    return database.rawDelete(query);
  }

  Future<int> deleteRow(dynamic id) => deleteWhere(
          where: WhereQuery(items: [
        WhereQueryItemCondition(
          column: index,
          condition: WhereQueryCondition.equals,
          value: id,
        ),
      ]));

  Future<List<Collection?>> allRows({
    List<String> columns = const [],
    List<SelectJoin> selectJoins = const [],
    WhereQuery? where,
    int? limit,
  }) async =>
      [
        for (final item in await select(
          columns: columns,
          selectJoins: selectJoins,
          where: where,
          limit: limit,
        ))
          Collection(item),
      ];

  Future<Collection?> findRow(
    dynamic id, {
    List<SelectJoin> selectJoins = const [],
  }) async {
    final result = await select(
      where: WhereQuery(items: [
        WhereQueryItemCondition(
          column: index,
          condition: WhereQueryCondition.equals,
          value: id,
        ),
      ]),
      selectJoins: selectJoins,
      limit: 1,
    );
    return result.isNotEmpty
        ? Collection(Map<String, dynamic>.from(result.first))
        : null;
  }

  Future<int?> createRow(Collection collection) => insert(collection.data);
}

class SelectJoin {
  final String migration;
  final String? migrationAs;
  final Map<String, String?>? columns;
  final WhereQuery? where;

  const SelectJoin(
    this.migration, {
    this.migrationAs,
    this.columns,
    this.where,
  });

  String get migrationName =>
      '`$migration`${migrationAs != null ? ' AS `$migrationAs`' : ''}';

  String get columnStr => columns != null
      ? ([
          for (MapEntry<String, String?> col in columns!.entries)
            '`${migrationAs ?? migration}`.`${col.key}`${col.value != null ? ' AS `${col.value}`' : ''}',
        ].join(',\n  '))
      : '`$migration`.*';
}
