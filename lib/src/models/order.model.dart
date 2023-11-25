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
    // MDateTime? chargingDate,
    // String? chargingAddress,
    // MDateTime? dischargingDate,
    // String? dischargingAddress,
    Map? details,
    List? images,
    MDateTime? createdAt,
  }) async {
    createdAt = createdAt ?? MDateTime.now();
    int? _id = await instance.createRow(Collection({
      'id': id,
      'from_client_id': fromClientId,
      'to_client_id': toClientId,
      // 'charging_date': chargingDate?.toString(),
      // 'charging_address': chargingAddress,
      // 'discharging_date': dischargingDate?.toString(),
      // 'discharging_address': dischargingAddress,
      'details': details,
      'images': images,
      'created_at': '$createdAt',
    }));
    return _id != null
        ? OrderCollection(
            _id,
            fromClientId,
            toClientId,
            // chargingDate,
            // chargingAddress,
            // dischargingDate,
            // dischargingAddress,
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
        // chargingDate: data['charging_date'] != null
        //     ? MDateTime.fromString(data['charging_date'])!
        //     : null,
        // chargingAddress: data['charging_address'],
        // dischargingDate: data['discharging_date'] != null
        //     ? MDateTime.fromString(data['discharging_date'])!
        //     : null,
        // dischargingAddress: data['discharging_address'],
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
  // MDateTime? chargingDate;
  // String? chargingAddress;
  // MDateTime? dischargingDate;
  // String? dischargingAddress;
  Map details;
  List images;
  final MDateTime createdAt;

  OrderCollection(
    this.id,
    this.fromClientId,
    this.toClientId,
    // this.chargingDate,
    // this.chargingAddress,
    // this.dischargingDate,
    // this.dischargingAddress,
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
        // data['charging_date'] != null
        //     ? MDateTime.fromString(data['charging_date'])!
        //     : null,
        // data['charging_address'],
        // data['discharging_date'] != null
        //     ? MDateTime.fromString(data['discharging_date'])!
        //     : null,
        // data['discharging_address'],
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
    // MDateTime? chargingDate,
    // String? chargingAddress,
    // MDateTime? dischargingDate,
    // String? dischargingAddress,
    Map? details,
    List? images,
  }) {
    this.fromClientId = fromClientId ?? this.fromClientId;
    this.toClientId = toClientId ?? this.toClientId;
    // this.chargingDate = chargingDate;
    // this.chargingAddress = chargingAddress;
    // this.dischargingDate = dischargingDate;
    // this.dischargingAddress = dischargingAddress;
    this.details = details ?? this.details;
    this.images = images ?? this.images;
    return OrderModel.instance.updateRow(id, data);
  }

  @override
  Map<String, dynamic> get data => {
        'id': id,
        'from_client_id': fromClientId,
        'to_client_id': toClientId,
        // 'charging_date': chargingDate?.toString(),
        // 'charging_address': chargingAddress,
        // 'discharging_date': dischargingDate?.toString(),
        // 'discharging_address': dischargingAddress,
        'details': jsonEncode(details),
        'images': jsonEncode(images),
        'created_at': '$createdAt',
      };

  @override
  String toString() => jsonEncode(data);
}
