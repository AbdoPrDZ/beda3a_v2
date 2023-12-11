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
    required UserCollection user,
    // required String username,
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
        ? ClientCollection(
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

  static Future<CreateEditResult<ClientCollection?>> createWithUser({
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

  // static Future<ClientCollection?> createFromMap(Map<String, dynamic> data) =>
  //     create(
  //       user: UserCollection.fromMap(data['user']),
  //       // username: data['username'],
  //       details: data['details'] != null
  //           ? Map<String, String>.from(jsonDecode(data['details']))
  //           : null,
  //       images: data['images'] != null
  //           ? List<String>.from(jsonDecode(data['images']))
  //           : null,
  //       createdAt: data['created_at'] != null
  //           ? MDateTime.fromString(data['created_at'])
  //           : null,
  //     );

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
              column: 'clients.user_id',
              value: '`users`.`id`',
              addQuotesIfString: false,
            ),
            isOnQuery: true,
          ),
        )
      ];

  static Future<List<ClientCollection>> allWhere({
    WhereQuery? where,
    int? limit,
  }) async =>
      [
        for (var row in await instance.select(
          columns: ['id', 'details', 'images', 'created_at'],
          selectJoins: selectJoins,
          where: where,
          limit: limit,
        ))
          ClientCollection.fromMap(row)
      ];

  static Future<List<ClientCollection>> all({int? limit}) =>
      allWhere(limit: limit);

  static Future<ClientCollection?> find(int id) async =>
      ClientCollection.fromCollectionNull(
        await instance.findRow(id, selectJoins: selectJoins),
      );

  static Future clear() async => instance.deleteWhere();
}

class ClientCollection extends Collection {
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

  ClientCollection(
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

  static ClientCollection fromMap(Map<String, dynamic> data) =>
      ClientCollection(
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

  static ClientCollection fromCollection(Collection collection) =>
      fromMap(collection.data);

  static ClientCollection? fromCollectionNull(Collection? collection) =>
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

  Map<String, dynamic> get dataWithUser => {
        ...data,
        'user_first_name': firstName,
        'user_last_name': lastName,
        'user_phone': phone,
        'user_email': email,
        'user_address': address,
        'user_company': company,
        'user_gender': gender,
      };

  @override
  String toString() => mJsonEncode(dataWithUser);
}
