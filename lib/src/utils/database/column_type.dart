class ColumnType {
  final String type;

  const ColumnType(this.type);

  static const ColumnType integer = ColumnType("INTEGER");
  static const ColumnType long = ColumnType("LONG");
  static const ColumnType short = ColumnType("SHORT");
  static const ColumnType real = ColumnType("REAL");
  static const ColumnType double = ColumnType("DOUBLE");
  static const ColumnType char = ColumnType("CHARACTER");
  static const ColumnType varChar = ColumnType("VARCHAR");
  static const ColumnType text = ColumnType("TEXT");
  static const ColumnType date = ColumnType("DATE");
  static const ColumnType time = ColumnType("TIME");
  static const ColumnType dateTime = ColumnType("DATETIME");
  static const ColumnType boolean = ColumnType("BOOLEAN");
  static ColumnType check(String colName, List<String> values) {
    String type = "CHECK($colName IN (";

    for (var i = 0; i < values.length; i++) {
      type += "'${values[i]}'";
      if (i < values.length - 1) type += ", ";
    }

    return ColumnType("$type))");
  }

  @override
  String toString() => type;
}
