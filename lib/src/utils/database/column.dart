import 'column_type.dart';

class Column {
  final String name;
  final ColumnType type;
  int? length;
  bool isPrimary;
  bool isAutoIncrement;
  bool isUnique;
  bool isNullable;
  dynamic defaultValue;
  bool setNullAsDefault;

  Column(
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

  static Column index({
    String name = 'id',
    ColumnType type = ColumnType.integer,
    int? length,
  }) =>
      Column(
        name,
        type: type,
        length: length,
        isPrimary: true,
        isAutoIncrement: true,
        isUnique: true,
      );

  static Column char(
    String name, {
    bool isUnique = false,
    bool isNullable = false,
    dynamic defaultValue,
    bool setNullAsDefault = false,
  }) =>
      Column(
        name,
        type: ColumnType.char,
        isUnique: isUnique,
        isNullable: isNullable,
        defaultValue: defaultValue,
        setNullAsDefault: setNullAsDefault,
      );

  static Column string(
    String name, {
    int? length = 255,
    bool isUnique = false,
    bool isNullable = false,
    dynamic defaultValue,
    bool setNullAsDefault = false,
  }) =>
      Column(
        name,
        type: ColumnType.varChar,
        length: length,
        isUnique: isUnique,
        isNullable: isNullable,
        defaultValue: defaultValue,
        setNullAsDefault: setNullAsDefault,
      );

  static Column text(
    String name, {
    int? length,
    bool isUnique = false,
    bool isNullable = false,
    dynamic defaultValue,
    bool setNullAsDefault = false,
  }) =>
      Column(
        name,
        type: ColumnType.text,
        length: length,
        isUnique: isUnique,
        isNullable: isNullable,
        defaultValue: defaultValue,
        setNullAsDefault: setNullAsDefault,
      );

  static Column integer(
    String name, {
    int? length = 100,
    bool isUnique = false,
    bool isNullable = false,
    dynamic defaultValue,
    bool setNullAsDefault = false,
    bool isAutoIncrement = false,
  }) =>
      Column(
        name,
        type: ColumnType.integer,
        length: length,
        isUnique: isUnique,
        isNullable: isNullable,
        defaultValue: defaultValue,
        setNullAsDefault: setNullAsDefault,
        isAutoIncrement: isAutoIncrement,
      );

  static Column long(
    String name, {
    int? length,
    bool isUnique = false,
    bool isNullable = false,
    dynamic defaultValue,
    bool setNullAsDefault = false,
  }) =>
      Column(
        name,
        type: ColumnType.long,
        length: length,
        isUnique: isUnique,
        isNullable: isNullable,
        defaultValue: defaultValue,
        setNullAsDefault: setNullAsDefault,
      );

  static Column short(
    String name, {
    int? length,
    bool isUnique = false,
    bool isNullable = false,
    dynamic defaultValue,
    bool setNullAsDefault = false,
  }) =>
      Column(
        name,
        type: ColumnType.short,
        length: length,
        isUnique: isUnique,
        isNullable: isNullable,
        defaultValue: defaultValue,
        setNullAsDefault: setNullAsDefault,
      );

  static Column real(
    String name, {
    int? length,
    bool isUnique = false,
    bool isNullable = false,
    dynamic defaultValue,
    bool setNullAsDefault = false,
  }) =>
      Column(
        name,
        type: ColumnType.real,
        length: length,
        isUnique: isUnique,
        isNullable: isNullable,
        defaultValue: defaultValue,
        setNullAsDefault: setNullAsDefault,
      );

  static Column double(
    String name, {
    int? length,
    bool isUnique = false,
    bool isNullable = false,
    dynamic defaultValue,
    bool setNullAsDefault = false,
  }) =>
      Column(
        name,
        type: ColumnType.double,
        length: length,
        isUnique: isUnique,
        isNullable: isNullable,
        defaultValue: defaultValue,
        setNullAsDefault: setNullAsDefault,
      );

  static Column boolean(
    String name, {
    int? length,
    bool isUnique = false,
    bool isNullable = false,
    dynamic defaultValue,
    bool setNullAsDefault = false,
  }) =>
      Column(
        name,
        type: ColumnType.boolean,
        length: length,
        isUnique: isUnique,
        isNullable: isNullable,
        defaultValue: defaultValue,
        setNullAsDefault: setNullAsDefault,
      );

  static Column date(
    String name, {
    bool isUnique = false,
    bool isNullable = false,
    dynamic defaultValue,
    bool setNullAsDefault = false,
    bool isAutoIncrement = false,
  }) =>
      Column(
        name,
        type: ColumnType.date,
        isUnique: isUnique,
        isNullable: isNullable,
        defaultValue: defaultValue,
        setNullAsDefault: setNullAsDefault,
        isAutoIncrement: isAutoIncrement,
      );

  static Column time(
    String name, {
    bool isUnique = false,
    bool isNullable = false,
    dynamic defaultValue,
    bool setNullAsDefault = false,
    bool isAutoIncrement = false,
  }) =>
      Column(
        name,
        type: ColumnType.time,
        isUnique: isUnique,
        isNullable: isNullable,
        defaultValue: defaultValue,
        setNullAsDefault: setNullAsDefault,
        isAutoIncrement: isAutoIncrement,
      );

  static Column dateTime(
    String name, {
    bool isUnique = false,
    bool isNullable = false,
    dynamic defaultValue,
    bool setNullAsDefault = false,
    bool isAutoIncrement = false,
  }) =>
      Column(
        name,
        type: ColumnType.dateTime,
        isUnique: isUnique,
        isNullable: isNullable,
        defaultValue: defaultValue,
        setNullAsDefault: setNullAsDefault,
        isAutoIncrement: isAutoIncrement,
      );

  static Column check(
    String name,
    List<String> values, {
    dynamic defaultValue,
    bool isNullable = false,
  }) =>
      Column(
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

  Column setLength(int length) {
    this.length = length;
    return this;
  }

  Column setDefault(dynamic value, {bool asNull = false}) {
    defaultValue = value;
    setNullAsDefault = asNull;
    return this;
  }

  Column autoIncrement({bool isAutoIncrement = true}) {
    this.isAutoIncrement = isAutoIncrement;
    return this;
  }

  Column unique({bool isUnique = true}) {
    this.isUnique = isUnique;
    return this;
  }

  Column nullable({bool isNullable = true}) {
    this.isNullable = isNullable;
    return this;
  }

  Column primary({bool isPrimary = true}) {
    this.isPrimary = isPrimary;
    return this;
  }

  @override
  String toString() => name;
}
