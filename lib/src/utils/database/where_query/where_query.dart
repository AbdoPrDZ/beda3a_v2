import 'where_query_item.dart';

export 'where_query_condition.dart';
export 'where_query_item.dart';

class WhereQuery {
  List<WhereQueryItem> items;
  bool isOnQuery;

  WhereQuery({this.items = const [], this.isOnQuery = false});

  static WhereQuery get instance => WhereQuery(items: []);

  static WhereQuery create(WhereQueryItem item, {bool isOnQuery = false}) =>
      WhereQuery(items: [item], isOnQuery: isOnQuery);

  WhereQuery add(WhereQueryItem item) {
    items.add(item);
    return this;
  }

  WhereQuery and(WhereQueryItem item) =>
      add(WhereQueryItemOperation.and).add(item);
  WhereQuery or(WhereQueryItem item) =>
      add(WhereQueryItemOperation.or).add(item);

  WhereQuery addCollection(List<WhereQueryItem> items) =>
      add(WhereQueryItemCollectionItems(items));
  WhereQuery andCollection(List<WhereQueryItem> items) =>
      add(WhereQueryItemOperation.and)
          .add(WhereQueryItemCollectionItems(items));
  WhereQuery orCollection(List<WhereQueryItem> items) =>
      add(WhereQueryItemOperation.or).add(WhereQueryItemCollectionItems(items));

  static WhereQuery merge(
    List<WhereQueryItem> conditions,
    WhereQueryItemOperation merge,
  ) =>
      WhereQuery(items: [
        for (var i = 0; i < conditions.length; i++) ...[
          conditions[i],
          if (i < conditions.length) merge
        ]
      ]);

  static WhereQuery mergeAnd(List<WhereQueryItem> conditions) =>
      merge(conditions, WhereQueryItemOperation.and);

  static WhereQuery mergeOr(List<WhereQueryItem> conditions) =>
      merge(conditions, WhereQueryItemOperation.or);

  @override
  String toString() => '${isOnQuery ? 'ON' : 'WHERE'} ${items.join(' ')}';

  WhereQuery operator +(Object item) {
    if (item is WhereQueryItem) {
      return add(item);
    } else if (item is List<WhereQueryItem>) {
      return add(WhereQueryItemCollectionItems(item));
    } else {
      throw Exception(
        'Cannot do this operation with this type (${item.runtimeType})',
      );
    }
  }
}
