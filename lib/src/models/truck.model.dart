import 'dart:convert';

import '../migrations/migrations.dart';
import '../utils/utils.dart';
import 'driver.model.dart';
import 'trip.model.dart';

class TruckModel extends Model {
  @override
  Migration get migration => TruckMigration();

  static TruckModel get instance => TruckModel();

  static Future<CreateEditResult<TruckCollection?>> create({
    int? id,
    required String name,
    int? driverId,
    Map<String, String>? details,
    List<String>? images,
    MDateTime? createdAt,
  }) async {
    createdAt = createdAt ?? MDateTime.now;
    int? _id = await instance.createRow(Collection({
      'id': id,
      'name': name,
      'driver_id': driverId,
      'current_trip_id': null,
      'details': details != null ? jsonEncode(details) : null,
      'images': images != null ? jsonEncode(images) : null,
      'created_at': '$createdAt',
    }));
    return CreateEditResult<TruckCollection?>(
      _id != null,
      result: _id != null
          ? TruckCollection(
              _id,
              name,
              driverId,
              null,
              details ?? {},
              images ?? [],
              createdAt,
            )
          : null,
    );
  }

  // static Future<CreateEditResult<TruckCollection?>> createFromMap(
  //         Map<String, dynamic> data) =>
  //     create(
  //       name: data['name'],
  //       driverId: data['driver_id'],
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
          'trips',
          columns: {
            'from': 'current_trip_from',
            'to': 'current_trip_to',
            'distance': 'current_trip_distance',
            'start_at': 'current_trip_start_at',
            'end_at': 'current_trip_end_at',
            'details': 'current_trip_details',
            'images': 'current_trip_images',
            'created_at': 'current_trip_created_at',
          },
          where: WhereQuery.create(
            WhereQueryItemCondition.equals(
              column: 'trucks.current_trip_id',
              value: '`trips`.`id`',
              addQuotesIfString: false,
            ),
            isOnQuery: true,
          ),
        )
      ];

  static Future<List<TruckCollection>> allWhere({
    WhereQuery? where,
    int? limit,
  }) async =>
      [
        for (var row in await instance.select(
          selectJoins: selectJoins,
          where: where,
          limit: limit,
        ))
          TruckCollection.fromMap(row)
      ];

  static Future<List<TruckCollection>> all({int? limit}) async =>
      allWhere(limit: limit);

  static Future<TruckCollection?> find(int id) async =>
      TruckCollection.fromCollectionNull(
        await instance.findRow(id, selectJoins: selectJoins),
      );

  static Future clear() async => instance.deleteWhere();
}

class TruckCollection extends Collection {
  final int id;
  String name;
  int? driverId;
  TripCollection? currentTrip;
  Map<String, String> details;
  List<String> images;
  final MDateTime createdAt;

  TruckCollection(
    this.id,
    this.name,
    this.driverId,
    this.currentTrip,
    this.details,
    this.images,
    this.createdAt,
  ) : super({});

  Future<DriverCollection?> get driver async =>
      driverId != null ? (await DriverModel.find(driverId!))! : null;

  static TruckCollection fromMap(Map<String, dynamic> data) {
    print(mJsonEncode(data));
    return TruckCollection(
      data['id'],
      data['name'],
      data['driver_id'],
      data['current_trip_id'] != null
          ? TripCollection(
              data['current_trip_id'],
              data['id'],
              data['current_trip_from'],
              data['current_trip_to'],
              data['current_trip_distance'] != null
                  ? double.parse(data['current_trip_distance'].toString())
                  : null,
              data['current_trip_start_at'] != null
                  ? MDateTime.fromString(data['current_trip_start_at'])
                  : null,
              data['current_trip_end_at'] != null
                  ? MDateTime.fromString(data['current_trip_end_at'])
                  : null,
              Map<String, String>.from(
                jsonDecode(data['current_trip_details']),
              ),
              List<String>.from(jsonDecode(data['current_trip_images'])),
              MDateTime.fromString(data['current_trip_created_at'])!,
            )
          : null,
      Map<String, String>.from(
          Map<String, String>.from(jsonDecode(data['details']))),
      List<String>.from(jsonDecode(data['images'])),
      MDateTime.fromString(data['created_at'])!,
    );
  }

  static TruckCollection fromCollection(Collection collection) =>
      fromMap(collection.data);

  static TruckCollection? fromCollectionNull(Collection? collection) =>
      collection != null ? fromMap(collection.data) : null;

  Future<CreateEditResult<int>> update({
    String? name,
    int? driverId,
    Map<String, String>? details,
    List<String>? images,
  }) async {
    this.name = name ?? this.name;
    this.driverId = driverId;
    this.details = details ?? this.details;
    this.images = images ?? this.images;
    return CreateEditResult<int>(true, result: await save());
  }

  Future<int> setCurrentTrip(TripCollection trip) {
    if (currentTrip != null) throw Exception("There already current trip");
    currentTrip = trip;
    return save();
  }

  Future<int> startCurrentTrip() {
    if (currentTrip == null) {
      throw Exception("There no current trip");
    } else if (driverId == null) {
      throw Exception("Can't start trip witout driver");
    }
    return currentTrip!.start();
  }

  Future<int> endCurrentTrip() {
    if (currentTrip == null) throw Exception("There no current trip");
    return currentTrip!.end();
  }

  Future<int> doneCurrentTrip() async {
    if (currentTrip == null) throw Exception("There no current trip");
    currentTrip = null;
    return await save();
  }

  Future<int> save() => TruckModel.instance.updateRow(id, data);

  Future<int> delete() => TruckModel.instance.deleteRow(id);

  @override
  Map<String, dynamic> get data => {
        'id': id,
        'name': name,
        'driver_id': driverId,
        'current_trip_id': currentTrip?.id,
        'details': jsonEncode(details),
        'images': jsonEncode(images),
        'created_at': '$createdAt',
      };

  @override
  String toString() => mJsonEncode(data);
}
