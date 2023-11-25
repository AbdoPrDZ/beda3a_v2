import 'dart:convert';

import '../migrations/migrations.dart';
import '../utils/utils.dart';
import 'user.model.dart';

class DriverModel extends Model {
  @override
  Migration get migration => DriverMigration();

  static DriverModel get instance => DriverModel();

  static Future<DriverCollection?> create({
    int? id,
    required int userId,
    // required String username,
    Map? details,
    List? images,
    MDateTime? createdAt,
  }) async {
    createdAt = createdAt ?? MDateTime.now();
    int? _id = await instance.createRow(Collection({
      'id': id,
      'user_id': userId,
      // 'username': username,
      'details': details,
      'images': images,
      'created_at': '$createdAt',
    }));
    return _id != null
        ? DriverCollection(
            _id,
            userId,
            // username,
            details ?? {},
            images ?? [],
            createdAt,
          )
        : null;
  }

  static Future<DriverCollection?> createFromMap(Map<String, dynamic> data) =>
      create(
        userId: data['user_id'],
        // username: data['username'],
        details: data['details'] != null ? jsonDecode(data['details']) : null,
        images: data['images'] != null ? jsonDecode(data['images']) : null,
        createdAt: data['created_at'] != null
            ? MDateTime.fromString(data['created_at'])
            : null,
      );

  static Future<List<DriverCollection>> all({int? limit}) async => [
        for (var coll in await instance.allRows(limit: limit))
          DriverCollection.fromCollection(coll as Collection)
      ];

  static Future<DriverCollection?> find(int id) async =>
      DriverCollection.fromCollectionNull(await instance.findRow(id));
}

class DriverCollection extends Collection {
  final int id;
  final int userId;
  // String username;
  Map details;
  List images;
  final MDateTime createdAt;

  DriverCollection(
    this.id,
    this.userId,
    // this.username,
    this.details,
    this.images,
    this.createdAt,
  ) : super({});

  Future<UserCollection> get user async => (await UserModel.find(userId))!;

  static DriverCollection fromMap(Map<String, dynamic> data) =>
      DriverCollection(
        data['id'],
        data['user_id'],
        // data['username'],
        jsonDecode(data['details']),
        jsonDecode(data['images']),
        MDateTime.fromString(data['created_at'])!,
      );

  static DriverCollection fromCollection(Collection collection) =>
      fromMap(collection.data);

  static DriverCollection? fromCollectionNull(Collection? collection) =>
      collection != null ? fromMap(collection.data) : null;

  Future<int> update({
    Map? details,
    List? images,
  }) {
    this.details = details ?? this.details;
    this.images = images ?? this.images;
    return DriverModel.instance.updateRow(id, data);
  }

  @override
  Map<String, dynamic> get data => {
        'id': id,
        'user_id': userId,
        // 'username': username,
        'details': jsonEncode(details),
        'images': jsonEncode(images),
        'created_at': '$createdAt',
      };

  @override
  String toString() => jsonEncode(data);
}
