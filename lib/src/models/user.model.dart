import 'dart:convert';

import '../migrations/user.migrate.dart';
import '../utils/utils.dart';

class UserModel extends Model {
  @override
  Migration get migration => UserMigration();

  static UserModel get instance => UserModel();

  static Future<UserCollection?> create({
    int? id,
    required String firstName,
    required String lastName,
    required String phone,
    String? email,
    String? address,
    String? company,
    required String gender,
    Map? details,
    List? images,
    MDateTime? createdAt,
  }) async {
    createdAt = createdAt ?? MDateTime.now();
    int? _id = await instance.createRow(Collection({
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'email': email,
      'address': address,
      'company': company,
      'gender': gender,
      'details': details,
      'images': images,
      'created_at': '$createdAt',
    }));
    return _id != null
        ? UserCollection(
            _id,
            firstName,
            lastName,
            phone,
            email,
            address,
            company,
            gender,
            details ?? {},
            images ?? [],
            createdAt,
          )
        : null;
  }

  static Future<UserCollection?> createFromMap(Map<String, dynamic> data) =>
      create(
        firstName: data['first_name'],
        lastName: data['last_name'],
        phone: data['phone'],
        email: data['email'],
        address: data['address'],
        company: data['company'],
        gender: data['gender'],
        details: data['details'] != null ? jsonDecode(data['details']) : null,
        images: data['images'] != null ? jsonDecode(data['images']) : null,
        createdAt: data['created_at'] != null
            ? MDateTime.fromString(data['created_at'])
            : null,
      );

  static Future<UserCollection?> createFromCollection(UserCollection user) =>
      createFromMap(user.data);

  static Future<List<UserCollection>> all({int? limit}) async => [
        for (var coll in await instance.allRows(limit: limit))
          UserCollection.fromCollection(coll as Collection)
      ];

  static Future<UserCollection?> find(int id) async =>
      UserCollection.fromCollectionNull(await instance.findRow(id));
}

class UserCollection extends Collection {
  final int id;
  String firstName;
  String lastName;
  String phone;
  String? email;
  String? address;
  String? company;
  String gender;
  Map details;
  List images;
  final MDateTime createdAt;

  UserCollection(
    this.id,
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

  String get fullName => '$firstName $lastName';

  static UserCollection fromMap(Map<String, dynamic> data) => UserCollection(
        data['id'],
        data['first_name'],
        data['last_name'],
        data['phone'],
        data['email'],
        data['address'],
        data['company'],
        data['gender'],
        jsonDecode(data['details']),
        jsonDecode(data['images']),
        MDateTime.fromString(data['created_at'])!,
      );

  static UserCollection fromCollection(Collection collection) =>
      fromMap(collection.data);

  static UserCollection? fromCollectionNull(Collection? collection) =>
      collection != null ? fromMap(collection.data) : null;

  Future<int> update({
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    String? address,
    String? company,
    String? gender,
    Map? details,
    List? images,
  }) {
    this.firstName = firstName ?? this.firstName;
    this.lastName = lastName ?? this.lastName;
    this.phone = phone ?? this.phone;
    this.email = email;
    this.address = address;
    this.company = company;
    this.gender = gender ?? this.gender;
    this.details = details ?? this.details;
    this.images = images ?? this.images;
    return save();
  }

  Future<int> save() => UserModel.instance.updateRow(id, data);

  Future<int> delete() => UserModel.instance.deleteRow(id);

  @override
  Map<String, dynamic> get data => {
        'id': id,
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
        'email': email,
        'address': address,
        'company': company,
        'gender': gender,
        'details': jsonEncode(details),
        'images': jsonEncode(images),
        'created_at': '$createdAt',
      };

  @override
  String toString() => jsonEncode(data);
}
