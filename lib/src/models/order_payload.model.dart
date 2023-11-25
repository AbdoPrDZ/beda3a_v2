import 'dart:convert';

import '../migrations/migrations.dart';
import '../utils/utils.dart';
import 'payload.model.dart';

class OrderPayloadModel extends Model {
  @override
  Migration get migration => OrderPayloadMigration();

  static OrderPayloadModel get instance => OrderPayloadModel();

  static Future<OrderPayloadCollection?> create({
    int? id,
    required int payloadId,
    required int count,
    String? selectedAddress,
    required double cost,
    required double price,
    MDateTime? chargingDate,
    String? chargingAddress,
    MDateTime? dischargingDate,
    String? dischargingAddress,
    required String gettingCostType,
    required double totalCost,
    required double totalPrice,
    required String gettingPriceType,
    required String gettingGeneralPriceType,
    required double generalPrice,
    Map? details,
    List? images,
    MDateTime? createdAt,
  }) async {
    createdAt = createdAt ?? MDateTime.now();
    int? _id = await instance.createRow(Collection({
      'id': id,
      'payload_id': payloadId,
      'count': count,
      'selected_address': selectedAddress,
      'charging_date': chargingDate?.toString(),
      'charging_address': chargingAddress,
      'discharging_date': dischargingDate?.toString(),
      'discharging_address': dischargingAddress,
      'cost': cost,
      'price': price,
      'getting_cost_type': gettingCostType,
      'total_cost': totalCost,
      'getting_price_type': gettingPriceType,
      'total_price': totalPrice,
      'getting_general_price_type': gettingGeneralPriceType,
      'general_price': generalPrice,
      'details': details,
      'images': images,
      'created_at': '$createdAt',
    }));
    return _id != null
        ? OrderPayloadCollection(
            _id,
            payloadId,
            count,
            selectedAddress,
            chargingDate,
            chargingAddress,
            dischargingDate,
            dischargingAddress,
            cost,
            price,
            gettingCostType,
            totalCost,
            gettingPriceType,
            totalPrice,
            gettingGeneralPriceType,
            generalPrice,
            details ?? {},
            images ?? [],
            createdAt,
          )
        : null;
  }

  static Future<OrderPayloadCollection?> createFromMap(
          Map<String, dynamic> data) =>
      create(
        payloadId: data['payload_id'],
        count: data['count'],
        selectedAddress: data['selected_address'],
        chargingDate: data['charging_date'] != null
            ? MDateTime.fromString(data['charging_date'])!
            : null,
        chargingAddress: data['charging_address'],
        dischargingDate: data['discharging_date'] != null
            ? MDateTime.fromString(data['discharging_date'])!
            : null,
        dischargingAddress: data['discharging_address'],
        cost: double.parse(data['cost'].toString()),
        price: double.parse(data['price'].toString()),
        gettingCostType: data['getting_cost_type'],
        totalCost: double.parse(data['total_cost'].toString()),
        gettingPriceType: data['getting_price_type'],
        totalPrice: double.parse(data['total_price'].toString()),
        generalPrice: double.parse(data['general_price'].toString()),
        gettingGeneralPriceType: data['getting_general_price_type'],
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
  int payloadId;
  int count;
  String? selectedAddress;
  MDateTime? chargingDate;
  String? chargingAddress;
  MDateTime? dischargingDate;
  String? dischargingAddress;
  double cost;
  double price;
  String gettingCostType;
  double totalCost;
  String gettingPriceType;
  double totalPrice;
  String gettingGeneralPriceType;
  double generalPrice;
  Map details;
  List images;
  final MDateTime createdAt;

  OrderPayloadCollection(
    this.id,
    this.payloadId,
    this.count,
    this.selectedAddress,
    this.chargingDate,
    this.chargingAddress,
    this.dischargingDate,
    this.dischargingAddress,
    this.cost,
    this.price,
    this.gettingCostType,
    this.totalCost,
    this.gettingPriceType,
    this.totalPrice,
    this.gettingGeneralPriceType,
    this.generalPrice,
    this.details,
    this.images,
    this.createdAt,
  ) : super({});

  Future<PayloadCollection> get paylaod async =>
      (await PayloadModel.find(payloadId))!;

  static OrderPayloadCollection fromMap(Map<String, dynamic> data) =>
      OrderPayloadCollection(
        data['id'],
        data['payload_id'],
        data['count'],
        data['selected_address'],
        data['charging_date'] != null
            ? MDateTime.fromString(data['charging_date'])!
            : null,
        data['charging_address'],
        data['discharging_date'] != null
            ? MDateTime.fromString(data['discharging_date'])!
            : null,
        data['discharging_address'],
        double.parse(data['cost'].toString()),
        double.parse(data['price'].toString()),
        data['getting_cost_type'],
        double.parse(data['total_cost'].toString()),
        data['getting_cost_type'],
        double.parse(data['total_price'].toString()),
        data['getting_general_price_type'],
        double.parse(data['general_price'].toString()),
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
    int? count,
    String? selectedAddress,
    MDateTime? chargingDate,
    String? chargingAddress,
    MDateTime? dischargingDate,
    String? dischargingAddress,
    double? cost,
    double? price,
    String? gettingCostType,
    double? totalCost,
    String? gettingPriceType,
    double? totalPrice,
    String? gettingGeneralPriceType,
    double? generalPrice,
    Map? details,
    List? images,
  }) {
    this.payloadId = payloadId ?? this.payloadId;
    this.count = count ?? this.count;
    this.selectedAddress = selectedAddress;
    this.chargingDate = chargingDate;
    this.chargingAddress = chargingAddress;
    this.dischargingDate = dischargingDate;
    this.dischargingAddress = dischargingAddress;
    this.cost = cost ?? this.cost;
    this.price = price ?? this.price;
    this.price = price ?? this.price;
    this.gettingCostType = gettingCostType ?? this.gettingCostType;
    this.totalCost = totalCost ?? this.totalCost;
    this.gettingPriceType = gettingPriceType ?? this.gettingPriceType;
    this.totalPrice = totalPrice ?? this.totalPrice;
    this.gettingGeneralPriceType =
        gettingGeneralPriceType ?? this.gettingGeneralPriceType;
    this.generalPrice = generalPrice ?? this.generalPrice;
    this.details = details ?? this.details;
    this.images = images ?? this.images;
    return save();
  }

  Future<int> save() => OrderPayloadModel.instance.updateRow(id, data);

  Future<int> delete() => OrderPayloadModel.instance.deleteRow(id);

  @override
  Map<String, dynamic> get data => {
        'id': id,
        'payload_id': payloadId,
        'count': count,
        'selected_address': selectedAddress,
        'charging_date': chargingDate?.toString(),
        'charging_address': chargingAddress,
        'discharging_date': dischargingDate?.toString(),
        'discharging_address': dischargingAddress,
        'cost': cost,
        'price': price,
        'getting_cost_type': gettingCostType,
        'total_cost': totalCost,
        'getting_price_type': gettingPriceType,
        'total_price': totalPrice,
        'getting_general_price_type': gettingGeneralPriceType,
        'general_price': generalPrice,
        'details': jsonEncode(details),
        'images': jsonEncode(images),
        'created_at': '$createdAt',
      };

  @override
  String toString() => jsonEncode(data);
}
