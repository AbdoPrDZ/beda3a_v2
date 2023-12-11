import 'package:get/get.dart';

import '../consts/costs.dart';
import 'page_info.dart';

class RouteManager {
  static Future<T?>? to<T, AT>(
    PageInfo page, {
    bool clearHeaders = false,
    AT? arguments,
    int? id,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
  }) =>
      clearHeaders
          ? Get.offAllNamed<T>(
              page.route,
              arguments: arguments,
              id: id,
              parameters: parameters,
            )
          : Get.toNamed<T>(
              page.route,
              arguments: arguments,
              id: id,
              preventDuplicates: preventDuplicates,
              parameters: parameters,
            );

  static List<GetPage> get pages {
    List<GetPage> pages = [];
    for (PageInfo pageInfo in PagesInfo.pages.values) {
      pages.add(
        GetPage(
          name: pageInfo.route,
          page: pageInfo.page,
          middlewares: PagesInfo.appMiddleWares,
          title: pageInfo.pageHeaders.title,
          participatesInRootNavigator:
              pageInfo.pageHeaders.participatesInRootNavigator,
          gestureWidth: pageInfo.pageHeaders.gestureWidth,
          maintainState: pageInfo.pageHeaders.maintainState,
          curve: pageInfo.pageHeaders.curve,
          alignment: pageInfo.pageHeaders.alignment,
          parameters: pageInfo.pageHeaders.parameters,
          opaque: pageInfo.pageHeaders.opaque,
          transitionDuration: pageInfo.pageHeaders.transitionDuration,
          popGesture: pageInfo.pageHeaders.popGesture,
          binding: pageInfo.pageHeaders.binding,
          bindings: pageInfo.pageHeaders.bindings,
          transition: pageInfo.pageHeaders.transition,
          customTransition: pageInfo.pageHeaders.customTransition,
          fullscreenDialog: pageInfo.pageHeaders.fullScreenDialog,
          showCupertinoParallax: pageInfo.pageHeaders.showCupertinoParallax,
          preventDuplicates: pageInfo.pageHeaders.preventDuplicates,
        ),
      );
    }
    return pages;
  }
}
