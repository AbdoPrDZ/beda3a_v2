import 'where_query_condition.dart';

abstract class WhereQueryItem {
  String get query;

  const WhereQueryItem();

  @override
  String toString() => query;
}

class WhereQueryItemOperation extends WhereQueryItem {
  final String name;

  const WhereQueryItemOperation(this.name);

  static const WhereQueryItemOperation and = WhereQueryItemOperation('AND');
  static const WhereQueryItemOperation or = WhereQueryItemOperation('OR');

  @override
  String get query => name;

  WhereQueryItemCollectionItems operator *(List<WhereQueryItem> items) =>
      WhereQueryItemCollectionItems([
        for (int i = 0; i < items.length; i++) ...[
          items[i],
          if (i < items.length - 1) this,
        ]
      ]);
}

class WhereQueryItemCondition<T> extends WhereQueryItem {
  final String column;
  final WhereQueryCondition condition;
  final T? value;
  final StringCase? stringCase;
  final bool addQuotesIfString;

  const WhereQueryItemCondition({
    required this.column,
    required this.condition,
    this.value,
    this.stringCase,
    this.addQuotesIfString = true,
  });

  static WhereQueryItemCondition<T> equals<T>({
    required String column,
    required T value,
    StringCase? stringCase,
    bool addQuotesIfString = true,
  }) =>
      WhereQueryItemCondition(
        column: column,
        condition: stringCase != null
            ? WhereQueryCondition.equal
            : WhereQueryCondition.equals,
        value: value,
        stringCase: stringCase,
        addQuotesIfString: addQuotesIfString,
      );

  static WhereQueryItemCondition<T> notEquals<T>({
    required String column,
    required T value,
    StringCase? stringCase,
    bool addQuotesIfString = true,
  }) =>
      WhereQueryItemCondition(
        column: column,
        condition: stringCase != null
            ? WhereQueryCondition.notEqual
            : WhereQueryCondition.notEquals,
        value: value,
        stringCase: stringCase,
        addQuotesIfString: addQuotesIfString,
      );

  static WhereQueryItemCondition inArray({
    required String column,
    required List<String> items,
    bool addQuotesIfString = true,
  }) =>
      WhereQueryItemCondition(
        column: column,
        condition: WhereQueryCondition.in_,
        value: "('${items.join("', '")}')",
        addQuotesIfString: false,
      );

  static WhereQueryItemCondition notInArray({
    required String column,
    required List<String> items,
  }) =>
      WhereQueryItemCondition(
        column: column,
        condition: WhereQueryCondition.notIn,
        value: "('${items.join("', '")}')",
        addQuotesIfString: false,
      );

  static WhereQueryItemCondition<T> is_<T>({
    required String column,
    required T value,
  }) =>
      WhereQueryItemCondition(
        column: column,
        condition: WhereQueryCondition.is_,
        value: value,
      );

  static WhereQueryItemCondition<T> isNot<T>({
    required String column,
    required T value,
    bool addQuotesIfString = true,
  }) =>
      WhereQueryItemCondition(
        column: column,
        condition: WhereQueryCondition.isNot,
        value: value,
      );

  static WhereQueryItemCondition isNull({required String column}) =>
      WhereQueryItemCondition(
        column: column,
        condition: WhereQueryCondition.isNull,
      );

  static WhereQueryItemCondition isNotNull({required String column}) =>
      WhereQueryItemCondition(
        column: column,
        condition: WhereQueryCondition.isNotNull,
      );

  static WhereQueryItemCondition<T> greaterThan<T>({
    required String column,
    required T value,
  }) =>
      WhereQueryItemCondition(
        column: column,
        condition: WhereQueryCondition.greaterThan,
        value: value,
      );

  static WhereQueryItemCondition<T> lessThan<T>({
    required String column,
    required T value,
  }) =>
      WhereQueryItemCondition(
        column: column,
        condition: WhereQueryCondition.lessThan,
        value: value,
      );

  static WhereQueryItemCondition like({
    required String column,
    required String value,
    StringCase? stringCase,
    bool addQuotesIfString = true,
  }) =>
      WhereQueryItemCondition(
        column: column,
        condition: WhereQueryCondition.like,
        value: value,
        stringCase: stringCase,
        addQuotesIfString: addQuotesIfString,
      );

  static WhereQueryItemCondition notLike({
    required String column,
    required String value,
    StringCase? stringCase,
    bool addQuotesIfString = true,
  }) =>
      WhereQueryItemCondition(
        column: column,
        condition: WhereQueryCondition.notLike,
        value: value,
        stringCase: stringCase,
        addQuotesIfString: addQuotesIfString,
      );

  @override
  String get query {
    String columnStr = '`${column.replaceAll('.', '`.`')}`';
    if (stringCase != null) columnStr = '$stringCase($columnStr)';
    return '$columnStr $condition '
        '${value == null ? 'NULL' : value is String && addQuotesIfString ? "'$value'" : '$value'}';
  }
}

class WhereQueryItemCollectionItems extends WhereQueryItem {
  final List<WhereQueryItem> items;

  const WhereQueryItemCollectionItems(this.items);

  @override
  String get query => '(${items.join(" ")})';
}

enum StringCase {
  lower,
  upper;

  @override
  String toString() => {lower: 'LOWER', upper: 'UPPER'}[this]!;
}
