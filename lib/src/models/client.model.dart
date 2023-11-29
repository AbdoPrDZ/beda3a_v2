import 'dart:convert';

import '../migrations/client.migrate.dart';
import '../utils/utils.dart';
import 'user.model.dart';

class ClientModel extends Model {
  @override
  Migration get migration => ClientMigration();

  static ClientModel get instance => ClientModel();

  static Future<ClientCollection?> create({
    int? id,
    required int userId,
    // required String username,
    Map<String, String>? details,
    List<String>? images,
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
        ? ClientCollection(
            _id,
            userId,
            // username,
            details ?? {},
            images ?? [],
            createdAt,
          )
        : null;
  }

  static Future<ClientCollection?> createFromMap(Map<String, dynamic> data) =>
      create(
        userId: data['user_id'],
        // username: data['username'],
        details: data['details'] != null
            ? Map<String, String>.from(jsonDecode(data['details']))
            : null,
        images: data['images'] != null
            ? List<String>.from(jsonDecode(data['images']))
            : null,
        createdAt: data['created_at'] != null
            ? MDateTime.fromString(data['created_at'])
            : null,
      );

  static Future<List<ClientCollection>> all({int? limit}) async => [
        for (var coll in await instance.allRows(limit: limit))
          ClientCollection.fromCollection(coll as Collection)
      ];

  static Future<ClientCollection?> find(int id) async =>
      ClientCollection.fromCollectionNull(await instance.findRow(id));
}

class ClientCollection extends Collection {
  final int id;
  final int userId;
  // String username;
  Map<String, String> details;
  List<String> images;
  final MDateTime createdAt;

  ClientCollection(
    this.id,
    this.userId,
    // this.username,
    this.details,
    this.images,
    this.createdAt,
  ) : super({});

  Future<UserCollection> get user async => (await UserModel.find(userId))!;

  static ClientCollection fromMap(Map<String, dynamic> data) =>
      ClientCollection(
        data['id'],
        data['user_id'],
        // data['username'],
        Map<String, String>.from(jsonDecode(data['details'])),
        List<String>.from(jsonDecode(data['images'])),
        MDateTime.fromString(data['created_at'])!,
      );

  static ClientCollection fromCollection(Collection collection) =>
      fromMap(collection.data);

  static ClientCollection? fromCollectionNull(Collection? collection) =>
      collection != null ? fromMap(collection.data) : null;

  Future<int> update({
    Map<String, String>? details,
    List<String>? images,
  }) {
    this.details = details ?? this.details;
    this.images = images ?? this.images;
    return save();
  }

  Future<int> save() => ClientModel.instance.updateRow(id, data);

  Future<int> delete() => ClientModel.instance.deleteRow(id);

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
