import '../migrations/migrations.dart';
import '../utils/utils.dart';

class SettingModel extends Model {
  @override
  Migration get migration => SettingMigration();

  static SettingModel get instance => SettingModel();

  static Future<SettingCollection?> create({
    int? id,
    required String name,
    String? value,
    MDateTime? createdAt,
  }) async {
    createdAt = createdAt ?? MDateTime.now();
    int? _id = await instance.createRow(Collection({
      'id': id,
      'name': name,
      'value': value,
      'created_at': '$createdAt',
    }));
    return _id != null
        ? SettingCollection(
            _id,
            name,
            value,
            createdAt,
          )
        : null;
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

  static Future<SettingCollection?> find(int id) async =>
      SettingCollection.fromCollectionNull(await instance.findRow(id));
}

class SettingCollection extends Collection {
  final int id;
  String name;
  String? value;
  final MDateTime createdAt;

  SettingCollection(
    this.id,
    this.name,
    this.value,
    this.createdAt,
  ) : super({});

  static SettingCollection fromMap(Map<String, dynamic> data) =>
      SettingCollection(
        data['id'],
        data['name'],
        data['value'],
        MDateTime.fromString(data['created_at'])!,
      );

  static SettingCollection fromCollection(Collection collection) =>
      fromMap(collection.data);

  static SettingCollection? fromCollectionNull(Collection? collection) =>
      collection != null ? fromMap(collection.data) : null;

  Future<int> update({
    String? name,
    String? value,
  }) {
    this.name = name ?? this.name;
    this.value = value;
    return save();
  }

  Future<int> save() => SettingModel.instance.updateRow(id, data);

  Future<int> delete() => SettingModel.instance.deleteRow(id);

  @override
  Map<String, dynamic> get data => {
        'id': id,
        'name': name,
        'value': value,
        'created_at': '$createdAt',
      };

  @override
  String toString() => jsonEncode(data);
}
