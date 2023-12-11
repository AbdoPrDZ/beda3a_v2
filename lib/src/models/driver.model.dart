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
    required UserCollection user,
    Map<String, String>? details,
    List<String>? images,
    MDateTime? createdAt,
  }) async {
    createdAt = createdAt ?? MDateTime.now;
    int? _id = await instance.createRow(Collection({
      'id': id,
      'user_id': user.id,
      // 'username': username,
      'details': details != null ? jsonEncode(details) : null,
      'images': images != null ? jsonEncode(images) : null,
      'created_at': '$createdAt',
    }));
    return _id != null
        ? DriverCollection(
            _id,
            user.id,
            // username,
            user.firstName,
            user.lastName,
            user.phone,
            user.email,
            user.address,
            user.company,
            user.gender,
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
    createdAt = createdAt ?? MDateTime.now;
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
        user: _user,
        details: details,
        images: images,
        createdAt: createdAt,
      ),
    );
  }

  static Future<DriverCollection?> createFromMap(Map<String, dynamic> data) =>
      create(
        user: UserCollection.fromMap(data['user']),
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

  static List<SelectJoin> get selectJoins => [
        SelectJoin(
          'users',
          columns: {
            'id': 'user_id',
            'first_name': null,
            'last_name': null,
            'phone': null,
            'email': null,
            'address': null,
            'company': null,
            'gender': null,
          },
          where: WhereQuery.create(
            WhereQueryItemCondition.equals(
              column: 'drivers.user_id',
              value: '`users`.`id`',
              addQuotesIfString: false,
            ),
            isOnQuery: true,
          ),
        )
      ];

  static Future<List<DriverCollection>> allWhere({
    WhereQuery? where,
    int? limit,
  }) async =>
      [
        for (var row in await instance.select(
          selectJoins: selectJoins,
          where: where,
          limit: limit,
        ))
          DriverCollection.fromMap(row)
      ];

  // static Future<List<DriverCollection>> all({int? limit}) async =>
  //     allWhere(limit: limit);

  static Future<DriverCollection?> find(int id) async =>
      DriverCollection.fromCollectionNull(
        await instance.findRow(id, selectJoins: selectJoins),
      );

  static Future clear() async => instance.deleteWhere();
}

class DriverCollection extends Collection {
  final int id;
  final int userId;
  // String username;
  String firstName;
  String lastName;
  String phone;
  String? email;
  String? address;
  String? company;
  String gender;
  Map<String, String> details;
  List<String> images;
  final MDateTime createdAt;

  DriverCollection(
    this.id,
    this.userId,
    // this.username,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.address,
    this.company,
    this.gender,
    this.details,
    this.images,
    this.createdAt,
  ) : super({});

  // Future<UserCollection> get user async => (await UserModel.find(userId))!;

  String get fullName => '$firstName $lastName';

  static DriverCollection fromMap(Map<String, dynamic> data) =>
      DriverCollection(
        data['id'],
        data['user_id'],
        // data['username'],
        data['first_name'],
        data['last_name'],
        data['phone'],
        data['email'],
        data['address'],
        data['company'],
        data['gender'],
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
    // await (await user).update(
    await UserModel.instance.updateRow(userId, {
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'email': email,
      'address': address,
      'company': company,
      'gender': gender,
    });
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
  String toString() => mJsonEncode({
        ...data,
        'user': {
          'firstName': firstName,
          'lastName': lastName,
          'phone': phone,
          'email': email,
          'address': address,
          'company': company,
          'gender': gender,
        }
      });
}
