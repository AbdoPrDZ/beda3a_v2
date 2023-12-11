import 'column_type.dart';

class TableColumn {
  final String name;
  final ColumnType type;
  int? length;
  bool isPrimary;
  bool isAutoIncrement;
  bool isUnique;
  bool isNullable;
  dynamic defaultValue;
  bool setNullAsDefault;

  TableColumn(
    this.name, {
    required this.type,
    this.length,
    this.isPrimary = false,
    this.isAutoIncrement = false,
    this.isUnique = false,
    this.isNullable = false,
    this.defaultValue,
    this.setNullAsDefault = false,
  });

  static TableColumn index({
    String name = 'id',
    ColumnType type = ColumnType.integer,
    int? length,
  }) =>
      TableColumn(
        name,
        type: type,
        length: length,
        isPrimary: true,
        isAutoIncrement: true,
        isUnique: true,
      );

  static TableColumn char(
    String name, {
    bool isUnique = false,
    bool isNullable = false,
    dynamic defaultValue,
    bool setNullAsDefault = false,
  }) =>
      TableColumn(
        name,
        type: ColumnType.char,
        isUnique: isUnique,
        isNullable: isNullable,
        defaultValue: defaultValue,
        setNullAsDefault: setNullAsDefault,
      );

  static TableColumn string(
    String name, {
    int? length = 255,
    bool isUnique = false,
    bool isNullable = false,
    dynamic defaultValue,
    bool setNullAsDefault = false,
  }) =>
      TableColumn(
        name,
        type: ColumnType.varChar,
        length: length,
        isUnique: isUnique,
        isNullable: isNullable,
        defaultValue: defaultValue,
        setNullAsDefault: setNullAsDefault,
      );

  static TableColumn text(
    String name, {
    int? length,
    bool isUnique = false,
    bool isNullable = false,
    dynamic defaultValue,
    bool setNullAsDefault = false,
  }) =>
      TableColumn(
        name,
        type: ColumnType.text,
        length: length,
        isUnique: isUnique,
        isNullable: isNullable,
        defaultValue: defaultValue,
        setNullAsDefault: setNullAsDefault,
      );

  static TableColumn integer(
    String name, {
    int? length = 100,
    bool isUnique = false,
    bool isNullable = false,
    dynamic defaultValue,
    bool setNullAsDefault = false,
    bool isAutoIncrement = false,
  }) =>
      TableColumn(
        name,
        type: ColumnType.integer,
        length: length,
        isUnique: isUnique,
        isNullable: isNullable,
        defaultValue: defaultValue,
        setNullAsDefault: setNullAsDefault,
        isAutoIncrement: isAutoIncrement,
      );

  static TableColumn long(
    String name, {
    int? length,
    bool isUnique = false,
    bool isNullable = false,
    dynamic defaultValue,
    bool setNullAsDefault = false,
  }) =>
      TableColumn(
        name,
        type: ColumnType.long,
        length: length,
        isUnique: isUnique,
        isNullable: isNullable,
        defaultValue: defaultValue,
        setNullAsDefault: setNullAsDefault,
      );

  static TableColumn short(
    String name, {
    int? length,
    bool isUnique = false,
    bool isNullable = false,
    dynamic defaultValue,
    bool setNullAsDefault = false,
  }) =>
      TableColumn(
        name,
        type: ColumnType.short,
        length: length,
        isUnique: isUnique,
        isNullable: isNullable,
        defaultValue: defaultValue,
        setNullAsDefault: setNullAsDefault,
      );

  static TableColumn real(
    String name, {
    int? length,
    bool isUnique = false,
    bool isNullable = false,
    dynamic defaultValue,
    bool setNullAsDefault = false,
  }) =>
      TableColumn(
        name,
        type: ColumnType.real,
        length: length,
        isUnique: isUnique,
        isNullable: isNullable,
        defaultValue: defaultValue,
        setNullAsDefault: setNullAsDefault,
      );

  static TableColumn double(
    String name, {
    int? length,
    bool isUnique = false,
    bool isNullable = false,
    dynamic defaultValue,
    bool setNullAsDefault = false,
  }) =>
      TableColumn(
        name,
        type: ColumnType.double,
        length: length,
        isUnique: isUnique,
        isNullable: isNullable,
        defaultValue: defaultValue,
        setNullAsDefault: setNullAsDefault,
      );

  static TableColumn boolean(
    String name, {
    int? length,
    bool isUnique = false,
    bool isNullable = false,
    dynamic defaultValue,
    bool setNullAsDefault = false,
  }) =>
      TableColumn(
        name,
        type: ColumnType.boolean,
        length: length,
        isUnique: isUnique,
        isNullable: isNullable,
        defaultValue: defaultValue,
        setNullAsDefault: setNullAsDefault,
      );

  static TableColumn date(
    String name, {
    bool isUnique = false,
    bool isNullable = false,
    dynamic defaultValue,
    bool setNullAsDefault = false,
    bool isAutoIncrement = false,
  }) =>
      TableColumn(
        name,
        type: ColumnType.date,
        isUnique: isUnique,
        isNullable: isNullable,
        defaultValue: defaultValue,
        setNullAsDefault: setNullAsDefault,
        isAutoIncrement: isAutoIncrement,
      );

  static TableColumn time(
    String name, {
    bool isUnique = false,
    bool isNullable = false,
    dynamic defaultValue,
    bool setNullAsDefault = false,
    bool isAutoIncrement = false,
  }) =>
      TableColumn(
        name,
        type: ColumnType.time,
        isUnique: isUnique,
        isNullable: isNullable,
        defaultValue: defaultValue,
        setNullAsDefault: setNullAsDefault,
        isAutoIncrement: isAutoIncrement,
      );

  static TableColumn dateTime(
    String name, {
    bool isUnique = false,
    bool isNullable = false,
    dynamic defaultValue,
    bool setNullAsDefault = false,
    bool isAutoIncrement = false,
  }) =>
      TableColumn(
        name,
        type: ColumnType.dateTime,
        isUnique: isUnique,
        isNullable: isNullable,
        defaultValue: defaultValue,
        setNullAsDefault: setNullAsDefault,
        isAutoIncrement: isAutoIncrement,
      );

  static TableColumn check(
    String name,
    List<String> values, {
    dynamic defaultValue,
    bool isNullable = false,
  }) =>
      TableColumn(
        name,
        type: ColumnType.check(name, values),
        defaultValue: defaultValue,
        isNullable: isNullable,
      );

  String get query {
    String query = "`$name` $type";

    if (length != null) query += "($length)";

    if (!isNullable) query += " NOT NULL";

    if (isPrimary) {
      query += " PRIMARY KEY";
      if (isAutoIncrement) {
        query += " AUTOINCREMENT";
      }
    }

    if (isUnique) query += " UNIQUE";

    if (defaultValue != null) {
      query +=
          " DEFAULT ${defaultValue is String ? "'$defaultValue'" : '$defaultValue'}";
    } else if (setNullAsDefault) {
      query += ' DEFAULT NULL';
    }

    return query;
  }

  TableColumn setLength(int length) {
    this.length = length;
    return this;
  }

  TableColumn setDefault(dynamic value, {bool asNull = false}) {
    defaultValue = value;
    setNullAsDefault = asNull;
    return this;
  }

  TableColumn autoIncrement({bool isAutoIncrement = true}) {
    this.isAutoIncrement = isAutoIncrement;
    return this;
  }

  TableColumn unique({bool isUnique = true}) {
    this.isUnique = isUnique;
    return this;
  }

  TableColumn nullable({bool isNullable = true}) {
    this.isNullable = isNullable;
    return this;
  }

  TableColumn primary({bool isPrimary = true}) {
    this.isPrimary = isPrimary;
    return this;
  }

  @override
  String toString() => name;
}
