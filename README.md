# Beda3a (Version 2)

A new Flutter project for Beda3a App this version uses sqlite to manage and store data.

<p align="center">
  <img src="assets/images/logo-1.png" width="50%" alt="Beda3a">
</p>

# Whats new

- I create new stricture to manage database easy and useful in `lib/src/utils/database`:
  - `database/database.dart`: initialize tha app database.
  - `database/migration.dart`: create tables with easy way.
  - `database/column.dart`: create table column with any type.
  - `database/column_type.dart`: used to set column type.
  - `database/where_query`: used to create where condition when searching.
    - `where_query/where_query.dart`: collect all files and export it.
    - `where_query/where_query_item.dart`: where condition item.
    - `where_query/where_query_condition.dart`: where conditions types.
    - `where_query/where_query_merge.dart`: merge types (and, or) to merge conditions.
  - `database/model.dart`: create table manager to insert, update and delete data.
  - `database/collections.dart`: manage table items (rows) (save, update, delete).

# Diagram:

<p align="center">
  <img src="screanshots/diagram.png" width="90%" alt="Beda3a Diagram">
</p>

# Utils:

## Database:

- ### Migration:
  This an abstract class so you can create your migrations with it, that required you to add name of table and table columns (List\<[Column](#column)>)
- ### Column:
  This an abstract class, that allow you to create an table column, that required you to set name of column and type and other parameters (primary, unique, not null, nullable, default...)
- ### Column Type:
  This an class that give many columns types. all types reserved as static getting functions (integer, long, short, real, double, char, varChar, text, date, time, dateTime, boolean, check)
- ### Collection:
  This an abstract class used to create an classes to stor your rows you collected from table as an object that makes you works easy and safe
- ### WhereQuery:
  This an class used to create where query statement with any form

## WhereQuery Examples:

```dart
void main() {
  WhereQuery query1 = WhereQuery.instance +
      WhereQueryItemCondition.equals(column: 'id', value: 1) +
      WhereQueryItemMerge.and +
      WhereQueryItemCondition.inArray(
        column: 'type',
        items: ['admin', 'sub_admin'],
      );
  print('SELECT * FROM `table1`$query1');
  // OUTPUT: SELECT * FROM `table1` WHERE `id` == 1 AND `type` IN ('admin', 'sub_admin')
  WhereQuery query2 = WhereQuery.instance
      .add(WhereQueryItemCondition.notEquals(column: 'id', value: 2))
      .or(WhereQueryItemCondition.notInArray(
        column: 'type',
        items: ['admin', 'sub_admin'],
      ));
  print('SELECT * FROM`table2`$query2');
  // OUTPUT: SELECT * FROM `table2` WHERE `id` != 2 OR `type` NOT IN ('admin', 'sub_admin')
  WhereQuery query3 = WhereQuery.instance.addCollection([
    WhereQueryItemCondition.equals(column: 'col1', value: 'val1'),
    WhereQueryItemMerge.or,
    WhereQueryItemCondition.equals(column: 'col2', value: 'val2')
  ]).andCollection([
    WhereQueryItemCondition.equals(column: 'col3', value: 'val3'),
    WhereQueryItemMerge.or,
    WhereQueryItemCondition.equals(column: 'col4', value: 'val4')
  ]);
  print('SELECT * FROM`table3`$query3');
  // OUTPUT: SELECT * FROM `table3` WHERE (`col1` == val1 OR `col2` == val2) AND (`col3` == val3 OR `col4` == val4)
  WhereQuery query4 = WhereQuery.instance +
      [
        WhereQueryItemCondition.equals(column: 'col1', value: 'val1'),
        WhereQueryItemMerge.and,
        WhereQueryItemCondition.equals(column: 'col2', value: 'val2')
      ] +
      WhereQueryItemMerge.or +
      [
        WhereQueryItemCondition.equals(column: 'col3', value: 'val3'),
        WhereQueryItemMerge.and,
        WhereQueryItemCondition.equals(column: 'col4', value: 'val4')
      ];
  print('SELECT * FROM`table4`$query4');
  // OUTPUT: SELECT * FROM `table4` WHERE (`col1` == val1 AND `col2` == val2) OR (`col3` == val3 AND `col4` == val4)
  WhereQuery query5 = WhereQuery.instance +
      WhereQueryItemMerge.and *
          [
            WhereQueryItemCondition.equals(column: 'column', value: 'value'),
            WhereQueryItemCondition.equals(column: 'column', value: 'value'),
          ] +
      WhereQueryItemMerge.or +
      WhereQueryItemCondition.greaterThan(column: 'column', value: 10);
  print('SELECT * FROM`table5`$query5');
  // OUTPUT: SELECT * FROM `table5` WHERE (`column` == value AND `column` == value) OR `column` > 10
}
```
