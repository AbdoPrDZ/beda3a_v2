import 'dart:convert' as convert;

import '../migrations/migrations.dart';
import '../utils/utils.dart';

class SettingModel extends Model {
  @override
  Migration get migration => SettingMigration();

  @override
  Column get index => Column.string('name');

  static SettingModel get instance => SettingModel();

  static Future<SettingCollection<T>> create<T>({
    required String name,
    T? value,
    MDateTime? createdAt,
  }) async {
    final coll = SettingCollection<T>(
      name,
      value,
      createdAt ?? MDateTime.now(),
    );
    await instance.createRow(coll);
    return coll;
  }

  static Future<SettingCollection?> createFromMap(Map<String, dynamic> data) =>
      create(
        name: data['name'],
        value: data['value'],
        createdAt: data['created_at'] != null
            ? MDateTime.fromString(data['created_at'])
            : null,
      );

  static Future<List<SettingCollection>> all({int? limit}) async => [
        for (var coll in await instance.allRows(limit: limit))
          SettingCollection.fromCollection(coll as Collection)
      ];

  static Future<SettingCollection<T>?> find<T>(String name) async =>
      SettingCollection.fromCollectionNull<T>(await instance.findRow(name));
}

class SettingCollection<T> extends Collection {
  String name;
  T? value;
  final MDateTime createdAt;

  SettingCollection(
    this.name,
    this.value,
    this.createdAt,
  ) : super({});

  static SettingCollection<T> fromMap<T>(Map<String, dynamic> data) =>
      SettingCollection(
        data['name'],
        data['value'] != null ? convert.jsonDecode(data['value']) as T? : null,
        MDateTime.fromString(data['created_at'])!,
      );

  static SettingCollection<T> fromCollection<T>(Collection collection) =>
      fromMap<T>(collection.data);

  static SettingCollection<T>? fromCollectionNull<T>(Collection? collection) =>
      collection != null ? fromMap<T>(collection.data) : null;

  Future<int> update({
    String? name,
    T? value,
  }) {
    this.name = name ?? this.name;
    this.value = value;
    return save();
  }

  Future<int> save() {
    return SettingModel.instance.updateRow(name, data);
  }

  Future<int> delete() => SettingModel.instance.deleteRow(name);

  @override
  Map<String, dynamic> get data => {
        'name': name,
        'value': value != null ? convert.jsonEncode(value!) : null,
        'created_at': '$createdAt',
      };

  @override
  String toString() => jsonEncode(data);
}
