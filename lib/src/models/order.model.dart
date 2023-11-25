import 'dart:convert';

import '../migrations/migrations.dart';
import '../utils/utils.dart';
import 'client.model.dart';

class OrderModel extends Model {
  @override
  Migration get migration => OrderMigration();

  static OrderModel get instance => OrderModel();

  static Future<OrderCollection?> create({
    int? id,
    required int fromClientId,
    required int toClientId,
    Map? details,
    List? images,
    MDateTime? createdAt,
  }) async {
    createdAt = createdAt ?? MDateTime.now();
    int? _id = await instance.createRow(Collection({
      'id': id,
      'from_client_id': fromClientId,
      'to_client_id': toClientId,
      'details': details,
      'images': images,
      'created_at': '$createdAt',
    }));
    return _id != null
        ? OrderCollection(
            _id,
            fromClientId,
            toClientId,
            details ?? {},
            images ?? [],
            createdAt,
          )
        : null;
  }

  static Future<OrderCollection?> createFromMap(Map<String, dynamic> data) =>
      create(
        fromClientId: data['from_client_id'],
        toClientId: data['to_client_id'],
        details: data['details'] != null ? jsonDecode(data['details']) : null,
        images: data['images'] != null ? jsonDecode(data['images']) : null,
        createdAt: data['created_at'] != null
            ? MDateTime.fromString(data['created_at'])
            : null,
      );

  static Future<List<OrderCollection>> all({int? limit}) async => [
        for (var coll in await instance.allRows(limit: limit))
          OrderCollection.fromCollection(coll as Collection)
      ];

  static Future<OrderCollection?> find(int id) async =>
      OrderCollection.fromCollectionNull(await instance.findRow(id));
}

class OrderCollection extends Collection {
  final int id;
  int fromClientId;
  int toClientId;
  Map details;
  List images;
  final MDateTime createdAt;

  OrderCollection(
    this.id,
    this.fromClientId,
    this.toClientId,
    this.details,
    this.images,
    this.createdAt,
  ) : super({});

  Future<ClientCollection> get fromClient async =>
      (await ClientModel.find(fromClientId))!;
  Future<ClientCollection> get toClient async =>
      (await ClientModel.find(toClientId))!;

  static OrderCollection fromMap(Map<String, dynamic> data) => OrderCollection(
        data['id'],
        data['from_client_id'],
        data['to_client_id'],
        jsonDecode(data['details']),
        jsonDecode(data['images']),
        MDateTime.fromString(data['created_at'])!,
      );

  static OrderCollection fromCollection(Collection collection) =>
      fromMap(collection.data);

  static OrderCollection? fromCollectionNull(Collection? collection) =>
      collection != null ? fromMap(collection.data) : null;

  Future<int> update({
    int? fromClientId,
    int? toClientId,
    Map? details,
    List? images,
  }) {
    this.fromClientId = fromClientId ?? this.fromClientId;
    this.toClientId = toClientId ?? this.toClientId;
    this.details = details ?? this.details;
    this.images = images ?? this.images;
    return save();
  }

  Future<int> save() => OrderModel.instance.updateRow(id, data);

  Future<int> delete() => OrderModel.instance.deleteRow(id);

  @override
  Map<String, dynamic> get data => {
        'id': id,
        'from_client_id': fromClientId,
        'to_client_id': toClientId,
        'details': jsonEncode(details),
        'images': jsonEncode(images),
        'created_at': '$createdAt',
      };

  @override
  String toString() => jsonEncode(data);
}
