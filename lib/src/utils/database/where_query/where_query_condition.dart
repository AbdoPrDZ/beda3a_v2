enum WhereQueryCondition {
  equal,
  equals,
  notEqual,
  notEquals,
  in_,
  notIn,
  is_,
  isNull,
  isNot,
  isNotNull,
  greaterThan,
  lessThan,
  like,
  notLike;

  @override
  String toString() => {
        equal: '=',
        equals: '==',
        notEquals: '!=',
        notEqual: '<>',
        in_: 'IN',
        notIn: 'NOT IN',
        is_: 'IS',
        isNull: 'IS NULL',
        isNot: 'IS NOT',
        isNotNull: 'IS NOT NULL',
        greaterThan: '>',
        lessThan: '<',
        like: 'LIKE',
        notLike: 'NOT LIKE',
      }[this]!;
}
