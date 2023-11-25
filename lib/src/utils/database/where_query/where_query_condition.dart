enum WhereQueryCondition {
  equals,
  in_,
  is_;

  @override
  String toString() => {equals: '==', in_: 'IN', is_: 'IS'}[this]!;
}
