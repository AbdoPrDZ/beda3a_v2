import 'dart:convert';

import '../migrations/migrations.dart';
import '../utils/utils.dart';

class PayloadModel extends Model {
  @override
  Migration get migration => PayloadMigration();

  static PayloadModel get instance => PayloadModel();

  static Future<CreateEditResult<PayloadCollection?>> create({
    int? id,
    required String name,
    required String category,
    String? description,
    required Map<String, PayloadAddress> addresses,
    Map<String, String>? details,
    List<String>? images,
    MDateTime? createdAt,
  }) async {
    createdAt = createdAt ?? MDateTime.now();
    int? _id = await instance.createRow(Collection({
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'addresses': jsonEncode({
        for (var address in addresses.values) address.address: address.map,
      }),
      'details': details != null ? jsonEncode(details) : null,
      'images': images != null ? jsonEncode(images) : null,
      'created_at': '$createdAt',
    }));
    return CreateEditResult(
      _id != null,
      result: _id != null
          ? PayloadCollection(
              _id,
              name,
              category,
              description,
              addresses,
              details ?? {},
              images ?? [],
              createdAt,
            )
          : null,
    );
  }

  static Future<CreateEditResult<PayloadCollection?>> createFromMap(
          Map<String, dynamic> data) =>
      create(
        name: data['name'],
        category: data['category'],
        description: data['description'],
        addresses: jsonDecode(data['addresses']),
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

  static Future<List<PayloadCollection>> all({int? limit}) async => [
        for (var coll in await instance.allRows(limit: limit))
          PayloadCollection.fromCollection(coll as Collection)
      ];

  static Future<PayloadCollection?> find(int id) async =>
      PayloadCollection.fromCollectionNull(await instance.findRow(id));

  static Future clear() async => instance.deleteWhere();
}

class PayloadCollection extends Collection {
  final int id;
  String name;
  String category;
  String? description;
  Map<String, PayloadAddress> addresses;
  Map<String, String> details;
  List<String> images;
  final MDateTime createdAt;

  PayloadCollection(
    this.id,
    this.name,
    this.category,
    this.description,
    this.addresses,
    this.details,
    this.images,
    this.createdAt,
  ) : super({});

  static PayloadCollection fromMap(Map<String, dynamic> data) =>
      PayloadCollection(
        data['id'],
        data['name'],
        data['category'],
        data['description'],
        PayloadAddress.allFromList(jsonDecode(data['addresses'])),
        Map<String, String>.from(jsonDecode(data['details'])),
        List<String>.from(jsonDecode(data['images'])),
        MDateTime.fromString(data['created_at'])!,
      );

  static PayloadCollection fromCollection(Collection collection) =>
      fromMap(collection.data);

  static PayloadCollection? fromCollectionNull(Collection? collection) =>
      collection != null ? fromMap(collection.data) : null;

  Future<CreateEditResult<int>> update({
    String? name,
    String? category,
    String? description,
    Map<String, PayloadAddress>? addresses,
    Map<String, String>? details,
    List<String>? images,
  }) async {
    this.name = name ?? this.name;
    this.category = category ?? this.category;
    this.description = category ?? this.description;
    this.addresses = addresses ?? this.addresses;
    this.details = details ?? this.details;
    this.images = images ?? this.images;
    return CreateEditResult(true, result: await save());
  }

  Future<int> save() => PayloadModel.instance.updateRow(id, data);

  Future<int> delete() => PayloadModel.instance.deleteRow(id);

  @override
  Map<String, dynamic> get data => {
        'id': id,
        'name': name,
        'category': category,
        'description': description,
        'addresses': jsonEncode({
          for (var address in addresses.values) address.address: address.map,
        }),
        'details': jsonEncode(details),
        'images': jsonEncode(images),
        'created_at': '$createdAt',
      };

  @override
  String toString() => jsonEncode(data);
}

class PayloadAddress {
  final String address;
  final double price, cost;

  const PayloadAddress(this.address, this.price, this.cost);

  static PayloadAddress fromMap(Map data) => PayloadAddress(
        data['address'],
        data['price'],
        data['cost'],
      );

  static Map<String, PayloadAddress> allFromList(Map items) => {
        for (String name in items.keys) name: fromMap(items[name]),
      };

  Map<String, dynamic> get map => {
        'address': address,
        'price': price,
        'cost': cost,
      };
}
