import 'dart:convert';

import '../migrations/migrations.dart';
import '../utils/utils.dart';

class ExpenseModel extends Model {
  @override
  Migration get migration => ExpenseMigration();

  static ExpenseModel get instance => ExpenseModel();

  static Future<ExpenseCollection?> create({
    int? id,
    required String name,
    required String address,
    required double cost,
    Map? details,
    List? images,
    MDateTime? createdAt,
  }) async {
    createdAt = createdAt ?? MDateTime.now();
    int? _id = await instance.createRow(Collection({
      'id': id,
      'name': name,
      'address': address,
      'cost': cost,
      'details': details,
      'images': images,
      'created_at': '$createdAt',
    }));
    return _id != null
        ? ExpenseCollection(
            _id,
            name,
            address,
            cost,
            details ?? {},
            images ?? [],
            createdAt,
          )
        : null;
  }

  static Future<ExpenseCollection?> createFromMap(Map<String, dynamic> data) =>
      create(
        name: data['name'],
        address: data['address'],
        cost: double.parse(data['cost'].toString()),
        details: data['details'] != null ? jsonDecode(data['details']) : null,
        images: data['images'] != null ? jsonDecode(data['images']) : null,
        createdAt: data['created_at'] != null
            ? MDateTime.fromString(data['created_at'])
            : null,
      );

  static Future<List<ExpenseCollection>> all({int? limit}) async => [
        for (var coll in await instance.allRows(limit: limit))
          ExpenseCollection.fromCollection(coll as Collection)
      ];

  static Future<ExpenseCollection?> find(int id) async =>
      ExpenseCollection.fromCollectionNull(await instance.findRow(id));
}

class ExpenseCollection extends Collection {
  final int id;
  String name;
  String address;
  double cost;
  Map details;
  List images;
  final MDateTime createdAt;

  ExpenseCollection(
    this.id,
    this.name,
    this.address,
    this.cost,
    this.details,
    this.images,
    this.createdAt,
  ) : super({});

  static ExpenseCollection fromMap(Map<String, dynamic> data) =>
      ExpenseCollection(
        data['id'],
        data['name'],
        data['address'],
        double.parse(data['cost'].toString()),
        jsonDecode(data['details']),
        jsonDecode(data['images']),
        MDateTime.fromString(data['created_at'])!,
      );

  static ExpenseCollection fromCollection(Collection collection) =>
      fromMap(collection.data);

  static ExpenseCollection? fromCollectionNull(Collection? collection) =>
      collection != null ? fromMap(collection.data) : null;

  Future<int> update({
    String? name,
    String? address,
    double? cost,
    Map? details,
    List? images,
  }) {
    this.name = name ?? this.name;
    this.address = address ?? this.address;
    this.cost = cost ?? this.cost;
    this.details = details ?? this.details;
    this.images = images ?? this.images;
    return ExpenseModel.instance.updateRow(id, data);
  }

  @override
  Map<String, dynamic> get data => {
        'id': id,
        'name': name,
        'address': address,
        'cost': cost,
        'details': jsonEncode(details),
        'images': jsonEncode(images),
        'created_at': '$createdAt',
      };

  @override
  String toString() => jsonEncode(data);
}
