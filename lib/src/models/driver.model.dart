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
    Map<String, String>? details,
    List<String>? images,
    MDateTime? createdAt,
  }) async {
    createdAt = createdAt ?? MDateTime.now();
    int? _id = await instance.createRow(Collection({
      'id': id,
      'user_id': userId,
      // 'username': username,
      'details': details != null ? jsonEncode(details) : null,
      'images': images != null ? jsonEncode(images) : null,
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

  static Future<CreateEditResult<DriverCollection?>> createWithUser({
    int? id,
    int? userId,
    required String firstName,
    required String lastName,
    required String phone,
    String? email,
    String? address,
    String? company,
    required String gender,
    Map<String, String>? details,
    List<String>? images,
    MDateTime? createdAt,
  }) async {
    createdAt = createdAt ?? MDateTime.now();
    UserCollection _user = (await UserModel.create(
      id: userId,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      email: email,
      gender: gender,
      address: address,
      company: company,
      createdAt: createdAt,
    ))!;
    return CreateEditResult(
      true,
      result: await create(
        id: id,
        userId: _user.id,
        details: details,
        images: images,
        createdAt: createdAt,
      ),
    );
  }

  static Future<DriverCollection?> createFromMap(Map<String, dynamic> data) =>
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

  static Future<List<DriverCollection>> all({int? limit}) async => [
        for (var coll in await instance.allRows(limit: limit))
          DriverCollection.fromCollection(coll as Collection)
      ];

  static Future<DriverCollection?> find(int id) async =>
      DriverCollection.fromCollectionNull(await instance.findRow(id));

  static Future clear() async => instance.deleteWhere();
}

class DriverCollection extends Collection {
  final int id;
  final int userId;
  // String username;
  Map<String, String> details;
  List<String> images;
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
        Map<String, String>.from(jsonDecode(data['details'])),
        List<String>.from(jsonDecode(data['images'])),
        MDateTime.fromString(data['created_at'])!,
      );

  static DriverCollection fromCollection(Collection collection) =>
      fromMap(collection.data);

  static DriverCollection? fromCollectionNull(Collection? collection) =>
      collection != null ? fromMap(collection.data) : null;

  Future<CreateEditResult<int>> update({
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    String? address,
    String? company,
    String? gender,
    Map<String, String>? details,
    List<String>? images,
  }) async {
    await (await user).update(
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      email: email,
      address: address,
      company: company,
      gender: gender,
    );
    this.details = details ?? this.details;
    this.images = images ?? this.images;
    return CreateEditResult(true, result: await save());
  }

  Future<int> save() => DriverModel.instance.updateRow(id, data);

  Future<int> delete() => DriverModel.instance.deleteRow(id);

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
