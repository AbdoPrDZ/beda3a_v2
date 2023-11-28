import 'dart:convert';

export 'database/database.dart';
export 'm_datetime.dart';
export 'size_config.dart';
export 'route_manager.dart';
export 'page_info.dart';
export 'page.dart';
export 'create_edit_page_data.dart';
export 'create_edit_model_result.dart';

String jsonEncode(Object object) =>
    const JsonEncoder.withIndent('  ').convert(object);

String getNameSymbols(String name, {String? splitter, String joiner = ''}) {
  name = name.trim();
  if (name.isEmpty) throw Exception("The name must be not empty");
  if (splitter != null ||
      name.contains(' ') ||
      name.contains('-') ||
      name.contains('_')) {
    final splits = splitter != null
        ? name.split(splitter)
        : name.contains('-')
            ? name.split('-')
            : name.contains('_')
                ? name.split('_')
                : name.split(' ');
    return [
      for (String item in splits.take(2)) item.substring(0, 1),
    ].join(joiner);
  } else {
    return name.substring(0, 2);
  }
}
