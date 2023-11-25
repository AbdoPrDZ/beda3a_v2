import 'dart:convert';

import '../migrations/migrations.dart';
import '../utils/utils.dart';

class TripModel extends Model {
  @override
  Migration get migration => TripMigration();

  static TripModel get instance => TripModel();

  static Future<TripCollection?> create({
    int? id,
    required String from,
    required String to,
    required double distance,
    MDateTime? startAt,
    MDateTime? endAt,
    Map? details,
    List? images,
    MDateTime? createdAt,
  }) async {
    createdAt = createdAt ?? MDateTime.now();
    int? _id = await instance.createRow(Collection({
      'id': id,
      'from': from,
      'to': to,
      'distance': distance,
      'start_at': startAt,
      'end_at': endAt,
      'details': details,
      'images': images,
      'created_at': '$createdAt',
    }));
    return _id != null
        ? TripCollection(
            _id,
            from,
            to,
            distance,
            startAt,
            endAt,
            details ?? {},
            images ?? [],
            createdAt,
          )
        : null;
  }

  static Future<TripCollection?> createFromMap(Map<String, dynamic> data) =>
      create(
        from: data['from'],
        to: data['to'],
        distance: data['distance'],
        startAt: data['start_at'] != null
            ? MDateTime.fromString(data['start_at'])
            : null,
        endAt: data['end_at'] != null
            ? MDateTime.fromString(data['end_at'])
            : null,
        details: data['details'] != null ? jsonDecode(data['details']) : null,
        images: data['images'] != null ? jsonDecode(data['images']) : null,
        createdAt: data['created_at'] != null
            ? MDateTime.fromString(data['created_at'])
            : null,
      );

  static Future<List<TripCollection>> all({int? limit}) async => [
        for (var coll in await instance.allRows(limit: limit))
          TripCollection.fromCollection(coll as Collection)
      ];

  static Future<TripCollection?> find(int id) async =>
      TripCollection.fromCollectionNull(await instance.findRow(id));
}

class TripCollection extends Collection {
  final int id;
  String from;
  String to;
  double distance;
  MDateTime? startAt;
  MDateTime? endAt;
  Map details;
  List images;
  final MDateTime createdAt;

  TripCollection(
    this.id,
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
        data['from'],
        data['to'],
        double.parse(data['distance'].toString()),
        MDateTime.fromString(data['start_at'])!,
        MDateTime.fromString(data['end_at'])!,
        jsonDecode(data['details']),
        jsonDecode(data['images']),
        MDateTime.fromString(data['created_at'])!,
      );

  static TripCollection fromCollection(Collection collection) =>
      fromMap(collection.data);

  static TripCollection? fromCollectionNull(Collection? collection) =>
      collection != null ? fromMap(collection.data) : null;

  Future<int> update({
    String? from,
    String? to,
    double? distance,
    MDateTime? startAt,
    MDateTime? endAt,
    Map? details,
    List? images,
  }) {
    this.from = from ?? this.from;
    this.to = to ?? this.to;
    this.distance = distance ?? this.distance;
    this.startAt = startAt;
    this.endAt = endAt;
    this.details = details ?? this.details;
    this.images = images ?? this.images;
    return save();
  }

  Future<int> save() => TripModel.instance.updateRow(id, data);

  Future<int> delete() => TripModel.instance.deleteRow(id);

  @override
  Map<String, dynamic> get data => {
        'id': id,
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
  String toString() => jsonEncode(data);
}
