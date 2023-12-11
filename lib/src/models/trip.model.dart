import 'dart:convert';

import '../migrations/migrations.dart';
import '../utils/utils.dart';
import 'order.model.dart';

class TripModel extends Model {
  @override
  Migration get migration => TripMigration();

  static TripModel get instance => TripModel();

  static Future<CreateEditResult<TripCollection?>> create({
    int? id,
    required int truckId,
    required String from,
    required String to,
    double? distance,
    MDateTime? startAt,
    MDateTime? endAt,
    Map<String, String>? details,
    List<String>? images,
    MDateTime? createdAt,
  }) async {
    createdAt = createdAt ?? MDateTime.now;
    int? _id = await instance.createRow(Collection({
      'id': id,
      'truck_id': truckId,
      'from': from,
      'to': to,
      'distance': distance,
      'start_at': startAt?.toString(),
      'end_at': endAt?.toString(),
      'details': details != null ? jsonEncode(details) : null,
      'images': images != null ? jsonEncode(images) : null,
      'created_at': '$createdAt',
    }));

    return CreateEditResult(
      _id != null,
      result: _id != null
          ? TripCollection(
              _id,
              truckId,
              from,
              to,
              distance,
              startAt,
              endAt,
              details ?? {},
              images ?? [],
              createdAt,
            )
          : null,
    );
  }

  static Future<CreateEditResult<TripCollection?>> createFromMap(
    Map<String, dynamic> data,
  ) =>
      create(
        truckId: data['truck_id'],
        from: data['from'],
        to: data['to'],
        distance: data['distance'] != null
            ? double.parse(data['distance'].toString())
            : null,
        startAt: data['start_at'] != null
            ? MDateTime.fromString(data['start_at'])
            : null,
        endAt: data['end_at'] != null
            ? MDateTime.fromString(data['end_at'])
            : null,
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

  // static Future<List<TripCollection>> all({int? limit}) async => [
  //       for (var coll in await instance.allRows(limit: limit))
  //         TripCollection.fromCollection(coll as Collection)
  //     ];

  static Future<List<TripCollection>> allWhere({
    WhereQuery? where,
    int? limit,
  }) async =>
      [
        for (var row in await instance.select(
          where: where,
          limit: limit,
        ))
          TripCollection.fromMap(row)
      ];

  static Future<TripCollection?> find(int id) async =>
      TripCollection.fromCollectionNull(await instance.findRow(id));

  static Future clear() async => instance.deleteWhere();
}

class TripCollection extends Collection {
  final int id;
  final int truckId;
  String from;
  String to;
  double? distance;
  MDateTime? startAt;
  MDateTime? endAt;
  Map<String, String> details;
  List<String> images;
  final MDateTime createdAt;

  TripCollection(
    this.id,
    this.truckId,
    this.from,
    this.to,
    this.distance,
    this.startAt,
    this.endAt,
    this.details,
    this.images,
    this.createdAt,
  ) : super({});

  static TripCollection fromMap(Map<String, dynamic> data) => TripCollection(
        data['id'],
        data['truck_id'],
        data['from'],
        data['to'],
        data['distance'] != null
            ? double.parse(data['distance'].toString())
            : null,
        data['start_at'] != null
            ? MDateTime.fromString(data['start_at'])
            : null,
        data['end_at'] != null ? MDateTime.fromString(data['end_at']) : null,
        Map<String, String>.from(jsonDecode(data['details'])),
        List<String>.from(jsonDecode(data['images'])),
        MDateTime.fromString(data['created_at'])!,
      );

  static TripCollection fromCollection(Collection collection) =>
      fromMap(collection.data);

  static TripCollection? fromCollectionNull(Collection? collection) =>
      collection != null ? fromMap(collection.data) : null;

  Future<CreateEditResult<int>> update({
    String? from,
    String? to,
    double? distance,
    MDateTime? startAt,
    MDateTime? endAt,
    Map<String, String>? details,
    List<String>? images,
  }) async {
    this.from = from ?? this.from;
    this.to = to ?? this.to;
    this.distance = distance;
    this.startAt = startAt;
    this.endAt = endAt;
    this.details = details ?? this.details;
    this.images = images ?? this.images;
    return CreateEditResult(true, result: await save());
  }

  Future<List<OrderCollection>> get orders => OrderModel.allWhere(
        where: WhereQuery.create(
          WhereQueryItemCondition.equals(column: 'orders.trip_id', value: id),
        ),
      );

  Future<int> start() async {
    if (startAt != null) {
      throw Exception("This trip is already started");
    } else if ((await orders).isEmpty) {
      throw Exception("Can't start trip without orders");
    }
    startAt = MDateTime.now;
    return await save();
  }

  Future<int> end() {
    if (startAt == null) {
      throw Exception("Can't end this trip without start it");
    } else if (endAt != null) {
      throw Exception("This trip is already ended");
    }
    endAt = MDateTime.now;
    return save();
  }

  Future<int> save() => TripModel.instance.updateRow(id, data);

  Future<int> delete() => TripModel.instance.deleteRow(id);

  @override
  Map<String, dynamic> get data => {
        'id': id,
        'truck_id': truckId,
        'from': from,
        'to': to,
        'distance': distance,
        'start_at': '$startAt',
        'end_at': '$endAt',
        'details': jsonEncode(details),
        'images': jsonEncode(images),
        'created_at': '$createdAt',
      };

  @override
  String toString() => mJsonEncode(data);
}
