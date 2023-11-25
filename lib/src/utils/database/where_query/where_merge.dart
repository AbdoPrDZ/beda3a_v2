enum WhereMerge {
  and,
  or;

  @override
  String toString() => {and: 'AND', or: 'OR'}[this]!;
}
