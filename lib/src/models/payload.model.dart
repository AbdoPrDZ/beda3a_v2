import 'dart:convert';

import '../migrations/migrations.dart';
import '../utils/utils.dart';

class PayloadModel extends Model {
  @override
  Migration get migration => PayloadMigration();

  static PayloadModel get instance => PayloadModel();

  static Future<PayloadCollection?> create({
    int? id,
    required String name,
    required String category,
    required String description,
    required Map addresses,
    Map? details,
    List? images,
    MDateTime? createdAt,
  }) async {
    createdAt = createdAt ?? MDateTime.now();
    int? _id = await instance.createRow(Collection({
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'addresses': addresses,
      'details': details,
      'images': images,
      'created_at': '$createdAt',
    }));
    return _id != null
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
        : null;
  }

  static Future<PayloadCollection?> createFromMap(Map<String, dynamic> data) =>
      create(
        name: data['name'],
        category: data['category'],
        description: data['description'],
        addresses: jsonDecode(data['addresses']),
        details: data['details'] != null ? jsonDecode(data['details']) : null,
        images: data['images'] != null ? jsonDecode(data['images']) : null,
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
}

class PayloadCollection extends Collection {
  final int id;
  String name;
  String category;
  String description;
  Map addresses;
  Map details;
  List images;
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
        jsonDecode(data['addresses']),
        jsonDecode(data['details']),
        jsonDecode(data['images']),
        MDateTime.fromString(data['created_at'])!,
      );

  static PayloadCollection fromCollection(Collection collection) =>
      fromMap(collection.data);

  static PayloadCollection? fromCollectionNull(Collection? collection) =>
      collection != null ? fromMap(collection.data) : null;

  Future<int> update({
    String? name,
    String? category,
    String? description,
    Map? addresses,
    Map? details,
    List? images,
  }) {
    this.name = name ?? this.name;
    this.category = category ?? this.category;
    this.description = category ?? this.description;
    this.addresses = addresses ?? this.addresses;
    this.details = details ?? this.details;
    this.images = images ?? this.images;
    return PayloadModel.instance.updateRow(id, data);
  }

  @override
  Map<String, dynamic> get data => {
        'id': id,
        'name': name,
        'category': category,
        'description': description,
        'addresses': jsonEncode(addresses),
        'details': jsonEncode(details),
        'images': jsonEncode(images),
        'created_at': '$createdAt',
      };

  @override
  String toString() => jsonEncode(data);
}
