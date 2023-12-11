import 'package:flutter/material.dart';

import 'page_headers.dart';

class PageInfo {
  final String route;
  final Widget Function() page;
  final bool isUnAuth;
  final PageHeaders pageHeaders;

  const PageInfo(this.route, this.page,
      {this.isUnAuth = false, this.pageHeaders = const PageHeaders()});

  @override
  operator ==(Object other) => other is String && other == route;
}
