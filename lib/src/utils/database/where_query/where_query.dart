import 'where_merge.dart';
import 'where_query_item.dart';

export 'where_merge.dart';
export 'where_query_condition.dart';
export 'where_query_item.dart';

class WhereQuery {
  final String query;

  const WhereQuery(this.query);

  static WhereQuery fromWhereQueryItems(
    List<WhereQueryItem> items, {
    WhereMerge whereMerge = WhereMerge.and,
  }) {
    String query = 'WHERE ';

    for (var i = 0; i < items.length; i++) {
      query += '${items[i]}';
      if (i < items.length - 1) query += ' $whereMerge ';
    }

    return WhereQuery(query);
  }

  @override
  String toString() => query;
}
