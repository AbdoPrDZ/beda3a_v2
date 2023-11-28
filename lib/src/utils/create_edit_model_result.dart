class CreateEditResult<Model> {
  final bool success;
  final String? message, fieldError;
  final Model? result;

  const CreateEditResult(
    this.success, {
    this.message,
    this.fieldError,
    this.result,
  });

  @override
  String toString() =>
      "CreateEditResult<$Model>(\n  success: $success\n  message: $message\n  fieldError: $fieldError\n  result: $result\n)";
}
