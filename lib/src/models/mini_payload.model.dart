import 'dart:convert';

import '../migrations/migrations.dart';
import '../utils/utils.dart';

class OrderPayloadModel extends Model {
  @override
  Migration get migration => OrderPayloadMigration();

  static OrderPayloadModel get instance => OrderPayloadModel();

  static Future<OrderPayloadCollection?> create({
    int? id,
    required String name,
    required String receiverName,
    required String receiverPhone,
    required double cost,
    MDateTime? chargingDate,
    String? chargingAddress,
    MDateTime? dischargingDate,
    String? dischargingAddress,
    Map? details,
    List? images,
    MDateTime? createdAt,
  }) async {
    createdAt = createdAt ?? MDateTime.now();
    int? _id = await instance.createRow(Collection({
      'id': id,
      'name': name,
      'receiver_name': receiverName,
      'receiver_phone': receiverPhone,
      'cost': cost,
      'charging_date': chargingDate?.toString(),
      'charging_address': chargingAddress,
      'discharging_date': dischargingDate?.toString(),
      'discharging_address': dischargingAddress,
      'details': details,
      'images': images,
      'created_at': '$createdAt',
    }));
    return _id != null
        ? OrderPayloadCollection(
            _id,
            name,
            receiverName,
            receiverPhone,
            cost,
            chargingDate,
            chargingAddress,
            dischargingDate,
            dischargingAddress,
            details ?? {},
            images ?? [],
            createdAt,
          )
        : null;
  }

  static Future<OrderPayloadCollection?> createFromMap(
          Map<String, dynamic> data) =>
      create(
        name: data['name'],
        receiverName: data['receiver_name'],
        receiverPhone: data['receiver_phone'],
        chargingDate: data['charging_date'] != null
            ? MDateTime.fromString(data['charging_date'])!
            : null,
        chargingAddress: data['charging_address'],
        dischargingDate: data['discharging_date'] != null
            ? MDateTime.fromString(data['discharging_date'])!
            : null,
        dischargingAddress: data['discharging_address'],
        cost: double.parse(data['cost'].toString()),
        details: data['details'] != null ? jsonDecode(data['details']) : null,
        images: data['images'] != null ? jsonDecode(data['images']) : null,
        createdAt: data['created_at'] != null
            ? MDateTime.fromString(data['created_at'])
            : null,
      );

  static Future<List<OrderPayloadCollection>> all({int? limit}) async => [
        for (var coll in await instance.allRows(limit: limit))
          OrderPayloadCollection.fromCollection(coll as Collection)
      ];

  static Future<OrderPayloadCollection?> find(int id) async =>
      OrderPayloadCollection.fromCollectionNull(await instance.findRow(id));
}

class OrderPayloadCollection extends Collection {
  final int id;
  String name;
  String receiverName;
  String receiverPhone;
  MDateTime? chargingDate;
  String? chargingAddress;
  MDateTime? dischargingDate;
  String? dischargingAddress;
  double cost;
  Map details;
  List images;
  final MDateTime createdAt;

  OrderPayloadCollection(
    this.id,
    this.name,
    this.receiverName,
    this.receiverPhone,
    this.cost,
    this.chargingDate,
    this.chargingAddress,
    this.dischargingDate,
    this.dischargingAddress,
    this.details,
    this.images,
    this.createdAt,
  ) : super({});

  static OrderPayloadCollection fromMap(Map<String, dynamic> data) =>
      OrderPayloadCollection(
        data['id'],
        data['name'],
        data['receiver_name'],
        data['receiver_phone'],
        double.parse(data['cost'].toString()),
        data['charging_date'] != null
            ? MDateTime.fromString(data['charging_date'])!
            : null,
        data['charging_address'],
        data['discharging_date'] != null
            ? MDateTime.fromString(data['discharging_date'])!
            : null,
        data['discharging_address'],
        jsonDecode(data['details']),
        jsonDecode(data['images']),
        MDateTime.fromString(data['created_at'])!,
      );

  static OrderPayloadCollection fromCollection(Collection collection) =>
      fromMap(collection.data);

  static OrderPayloadCollection? fromCollectionNull(Collection? collection) =>
      collection != null ? fromMap(collection.data) : null;

  Future<int> update({
    int? payloadId,
    String? name,
    String? receiverName,
    String? receiverPhone,
    double? cost,
    MDateTime? chargingDate,
    String? chargingAddress,
    MDateTime? dischargingDate,
    String? dischargingAddress,
    Map? details,
    List? images,
  }) {
    this.name = name ?? this.name;
    this.receiverName = receiverName ?? this.receiverName;
    this.receiverPhone = receiverPhone ?? this.receiverPhone;
    this.cost = cost ?? this.cost;
    this.chargingDate = chargingDate;
    this.chargingAddress = chargingAddress;
    this.dischargingDate = dischargingDate;
    this.dischargingAddress = dischargingAddress;
    this.details = details ?? this.details;
    this.images = images ?? this.images;
    return OrderPayloadModel.instance.updateRow(id, data);
  }

  @override
  Map<String, dynamic> get data => {
        'id': id,
        'name': name,
        'receiver_name': receiverName,
        'receiver_phone': receiverPhone,
        'cost': cost,
        'charging_date': chargingDate?.toString(),
        'charging_address': chargingAddress,
        'discharging_date': dischargingDate?.toString(),
        'discharging_address': dischargingAddress,
        'details': jsonEncode(details),
        'images': jsonEncode(images),
        'created_at': '$createdAt',
      };

  @override
  String toString() => jsonEncode(data);
}
