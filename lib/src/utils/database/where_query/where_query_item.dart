import 'where_query_condition.dart';

class WhereQueryItem<T> {
  final String column;
  final WhereQueryCondition condition;
  final T? value;

  const WhereQueryItem({
    required this.column,
    required this.condition,
    this.value,
  });

  @override
  String toString() =>
      '`$column` $condition ${value == null ? 'NULL' : value is String ? "'$value'" : '$value'}';
}
