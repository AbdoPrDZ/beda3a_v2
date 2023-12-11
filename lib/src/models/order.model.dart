import 'dart:convert';

import '../migrations/migrations.dart';
import '../utils/utils.dart';
import 'client.model.dart';

class OrderModel extends Model {
  @override
  Migration get migration => OrderMigration();

  static OrderModel get instance => OrderModel();

  static Future<CreateEditResult<OrderCollection?>> create({
    int? id,
    required int tripId,
    required ClientCollection fromClient,
    required ClientCollection toClient,
    Map<String, String>? details,
    List<String>? images,
    MDateTime? createdAt,
  }) async {
    createdAt = createdAt ?? MDateTime.now;
    int? _id = await instance.createRow(Collection({
      'id': id,
      'trip_id': tripId,
      'from_client_id': fromClient.id,
      'to_client_id': toClient.id,
      'details': details != null ? jsonEncode(details) : null,
      'images': images != null ? jsonEncode(images) : null,
      'created_at': '$createdAt',
    }));
    return CreateEditResult(_id != null,
        result: _id != null
            ? OrderCollection(
                _id,
                tripId,
                fromClient,
                toClient,
                details ?? {},
                images ?? [],
                createdAt,
              )
            : null);
  }

  static Future<CreateEditResult<OrderCollection?>> createFromMap(
          Map<String, dynamic> data) =>
      create(
        id: data['id'],
        tripId: data['trip_id'],
        fromClient: ClientCollection(
          data['from_client_id'],
          data['from_client_user_id'],
          data['from_client_user_first_name'],
          data['from_client_user_last_name'],
          data['from_client_user_phone'],
          data['from_client_user_email'],
          data['from_client_user_address'],
          data['from_client_user_company'],
          data['from_client_user_gender'],
          Map<String, String>.from(
            jsonDecode(data['from_client_details']),
          ),
          List<String>.from(
            jsonDecode(data['from_client_images']),
          ),
          MDateTime.fromString(data['from_client_created_at'])!,
        ),
        toClient: ClientCollection(
          data['to_client_id'],
          data['to_client_user_id'],
          data['to_client_user_first_name'],
          data['to_client_user_last_name'],
          data['to_client_user_phone'],
          data['to_client_user_email'],
          data['to_client_user_address'],
          data['to_client_user_company'],
          data['to_client_user_gender'],
          Map<String, String>.from(
            jsonDecode(data['to_client_details']),
          ),
          List<String>.from(
            jsonDecode(data['to_client_images']),
          ),
          MDateTime.fromString(data['to_client_created_at'])!,
        ),
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

  static Future<CreateEditResult<OrderCollection?>> createFromCollection(
          Collection collection) =>
      createFromMap(collection.data);

  static List<SelectJoin> get selectJoins => [
        SelectJoin(
          'clients',
          migrationAs: 'from_clients',
          columns: {
            'id': 'from_client_id',
            'details': 'from_client_details',
            'images': 'from_client_images',
            'created_at': 'from_client_created_at',
          },
          where: WhereQuery.create(
            WhereQueryItemCondition.equals(
              column: 'orders.from_client_id',
              value: '`from_clients`.`id`',
              addQuotesIfString: false,
            ),
            isOnQuery: true,
          ),
        ),
        SelectJoin(
          'clients',
          migrationAs: 'to_clients',
          columns: {
            'id': 'to_client_id',
            'details': 'to_client_details',
            'images': 'to_client_images',
            'created_at': 'to_client_created_at',
          },
          where: WhereQuery.create(
            WhereQueryItemCondition.equals(
              column: 'orders.to_client_id',
              value: '`to_clients`.`id`',
              addQuotesIfString: false,
            ),
            isOnQuery: true,
          ),
        ),
        SelectJoin(
          'users',
          migrationAs: 'from_users',
          columns: {
            'id': 'from_client_user_id',
            'first_name': 'from_client_user_first_name',
            'last_name': 'from_client_user_last_name',
            'phone': 'from_client_user_phone',
            'email': 'from_client_user_email',
            'address': 'from_client_user_address',
            'company': 'from_client_user_company',
            'gender': 'from_client_user_gender',
          },
          where: WhereQuery.create(
            WhereQueryItemCondition.equals(
              column: 'from_clients.user_id',
              value: '`from_users`.`id`',
              addQuotesIfString: false,
            ),
            isOnQuery: true,
          ),
        ),
        SelectJoin(
          'users',
          migrationAs: 'to_users',
          columns: {
            'id': 'to_client_user_id',
            'first_name': 'to_client_user_first_name',
            'last_name': 'to_client_user_last_name',
            'phone': 'to_client_user_phone',
            'email': 'to_client_user_email',
            'address': 'to_client_user_address',
            'company': 'to_client_user_company',
            'gender': 'to_client_user_gender',
          },
          where: WhereQuery.create(
            WhereQueryItemCondition.equals(
              column: 'to_clients.user_id',
              value: '`to_users`.`id`',
              addQuotesIfString: false,
            ),
            isOnQuery: true,
          ),
        )
      ];

  static Future<List<OrderCollection>> allWhere({
    WhereQuery? where,
    int? limit,
  }) async =>
      [
        for (var row in await instance.select(
          selectJoins: selectJoins,
          where: where,
          limit: limit,
        ))
          OrderCollection.fromMap(row)
      ];

  static Future<List<OrderCollection>> all({int? limit}) async =>
      allWhere(limit: limit);

  static Future<OrderCollection?> find(int id) async =>
      OrderCollection.fromCollectionNull(
        await instance.findRow(id, selectJoins: selectJoins),
      );
}

class OrderCollection extends Collection {
  final int? id;
  int? tripId;
  ClientCollection fromClient;
  ClientCollection toClient;
  Map<String, String> details;
  List<String> images;
  final MDateTime createdAt;

  OrderCollection(
    this.id,
    this.tripId,
    this.fromClient,
    this.toClient,
    this.details,
    this.images,
    this.createdAt,
  ) : super({});

  // Future<ClientCollection> get fromClient async =>
  //     (await ClientModel.find(fromClientId))!;
  // Future<ClientCollection> get toClient async =>
  //     (await ClientModel.find(toClientId))!;

  static OrderCollection fromMap(Map<String, dynamic> data) => OrderCollection(
        data['id'],
        data['trip_id'],
        ClientCollection(
          data['from_client_id'],
          data['from_client_user_id'],
          data['from_client_user_first_name'],
          data['from_client_user_last_name'],
          data['from_client_user_phone'],
          data['from_client_user_email'],
          data['from_client_user_address'],
          data['from_client_user_company'],
          data['from_client_user_gender'],
          Map<String, String>.from(
            jsonDecode(data['from_client_details']),
          ),
          List<String>.from(
            jsonDecode(data['from_client_images']),
          ),
          MDateTime.fromString(data['from_client_created_at'])!,
        ),
        ClientCollection(
          data['to_client_id'],
          data['to_client_user_id'],
          data['to_client_user_first_name'],
          data['to_client_user_last_name'],
          data['to_client_user_phone'],
          data['to_client_user_email'],
          data['to_client_user_address'],
          data['to_client_user_company'],
          data['to_client_user_gender'],
          Map<String, String>.from(
            jsonDecode(data['to_client_details']),
          ),
          List<String>.from(
            jsonDecode(data['to_client_images']),
          ),
          MDateTime.fromString(data['to_client_created_at'])!,
        ),
        Map<String, String>.from(jsonDecode(data['details'])),
        List<String>.from(jsonDecode(data['images'])),
        MDateTime.fromString(data['created_at'])!,
      );

  static OrderCollection fromCollection(Collection collection) =>
      fromMap(collection.data);

  static OrderCollection? fromCollectionNull(Collection? collection) =>
      collection != null ? fromMap(collection.data) : null;

  Future<CreateEditResult<int>> update({
    ClientCollection? fromClient,
    ClientCollection? toClient,
    Map<String, String>? details,
    List<String>? images,
  }) async {
    this.fromClient = fromClient ?? this.fromClient;
    this.toClient = toClient ?? this.toClient;
    this.details = details ?? this.details;
    this.images = images ?? this.images;
    return CreateEditResult(true, result: await save());
  }

  Future<int> save() => OrderModel.instance.updateRow(id, data);

  Future<int> delete() => OrderModel.instance.deleteRow(id);

  @override
  Map<String, dynamic> get data => {
        'id': id,
        'trip_id': tripId,
        'from_client_id': fromClient.id,
        'to_client_id': toClient.id,
        'details': jsonEncode(details),
        'images': jsonEncode(images),
        'created_at': '$createdAt',
      };

  Map<String, dynamic> get dataWithClients => {
        ...data,
        for (String key in fromClient.dataWithUser.keys)
          'from_client_$key': fromClient.dataWithUser[key],
        for (String key in toClient.dataWithUser.keys)
          'to_client_$key': toClient.dataWithUser[key],
      };

  @override
  String toString() => jsonEncode(data);
}
