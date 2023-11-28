import 'dart:convert';

import '../migrations/migrations.dart';
import '../utils/utils.dart';
import 'driver.model.dart';

class TruckModel extends Model {
  @override
  Migration get migration => TruckMigration();

  static TruckModel get instance => TruckModel();

  static Future<CreateEditResult<TruckCollection?>> create({
    int? id,
    required String name,
    int? driverId,
    Map<String, String>? details,
    List? images,
    MDateTime? createdAt,
  }) async {
    createdAt = createdAt ?? MDateTime.now();
    int? _id = await instance.createRow(Collection({
      'id': id,
      'name': name,
      'driver_id': driverId,
      'details': details != null ? jsonEncode(details) : null,
      'images': images,
      'created_at': '$createdAt',
    }));
    return CreateEditResult<TruckCollection?>(
      _id != null,
      result: _id != null
          ? TruckCollection(
              _id,
              name,
              driverId,
              details ?? {},
              images ?? [],
              createdAt,
            )
          : null,
    );
  }

  static Future<CreateEditResult<TruckCollection?>> createFromMap(
          Map<String, dynamic> data) =>
      create(
        name: data['name'],
        driverId: data['driver_id'],
        details: data['details'] != null ? jsonDecode(data['details']) : null,
        images: data['images'] != null ? jsonDecode(data['images']) : null,
        createdAt: data['created_at'] != null
            ? MDateTime.fromString(data['created_at'])
            : null,
      );

  static Future<List<TruckCollection>> all({int? limit}) async => [
        for (var coll in await instance.allRows(limit: limit))
          TruckCollection.fromCollection(coll as Collection)
      ];

  static Future<TruckCollection?> find(int id) async =>
      TruckCollection.fromCollectionNull(await instance.findRow(id));

  static Future clear() async => instance.deleteWhere();
}

class TruckCollection extends Collection {
  final int id;
  String name;
  int? driverId;
  Map<String, String> details;
  List images;
  final MDateTime createdAt;

  TruckCollection(
    this.id,
    this.name,
    this.driverId,
    this.details,
    this.images,
    this.createdAt,
  ) : super({});

  Future<DriverCollection?> get driver async =>
      driverId != null ? (await DriverModel.find(driverId!))! : null;

  static TruckCollection fromMap(Map<String, dynamic> data) => TruckCollection(
        data['id'],
        data['name'],
        data['driver_id'],
        Map<String, String>.from(jsonDecode(data['details'])),
        jsonDecode(data['images']),
        MDateTime.fromString(data['created_at'])!,
      );

  static TruckCollection fromCollection(Collection collection) =>
      fromMap(collection.data);

  static TruckCollection? fromCollectionNull(Collection? collection) =>
      collection != null ? fromMap(collection.data) : null;

  Future<CreateEditResult<int>> update({
    String? name,
    int? driverId,
    Map<String, String>? details,
    List? images,
  }) async {
    this.name = name ?? this.name;
    this.driverId = driverId;
    this.details = details ?? this.details;
    this.images = images ?? this.images;
    return CreateEditResult<int>(true, result: await save());
  }

  Future<int> save() => TruckModel.instance.updateRow(id, data);

  Future<int> delete() => TruckModel.instance.deleteRow(id);

  @override
  Map<String, dynamic> get data => {
        'id': id,
        'name': name,
        'driver_id': driverId,
        'details': jsonEncode(details),
        'images': jsonEncode(images),
        'created_at': '$createdAt',
      };

  @override
  String toString() => jsonEncode(data);
}
