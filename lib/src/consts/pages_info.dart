import 'package:get/get.dart';

import '../../middlewares/auth.middleware.dart';
import '../../pages/pages.dart';
import '../utils/utils.dart';

class PagesInfo {
  static Map<String, PageInfo> get pages => {
        LoadingPage.name:
            PageInfo(LoadingPage.name, () => LoadingPage(), isUnAuth: true),
        LoginPage.name:
            PageInfo(LoginPage.name, () => LoginPage(), isUnAuth: true),
        SetupUserPage.name:
            PageInfo(SetupUserPage.name, () => SetupUserPage(), isUnAuth: true),
        HomePage.name: PageInfo(HomePage.name, () => HomePage()),
        CreateEditTruckPage.name:
            PageInfo(CreateEditTruckPage.name, () => CreateEditTruckPage()),
        CreateEditDriverPage.name:
            PageInfo(CreateEditDriverPage.name, () => CreateEditDriverPage()),
        CreateEditClientPage.name:
            PageInfo(CreateEditClientPage.name, () => CreateEditClientPage()),
        CreateEditPayloadPage.name:
            PageInfo(CreateEditPayloadPage.name, () => CreateEditPayloadPage()),
        CreateEditTripPage.name:
            PageInfo(CreateEditTripPage.name, () => CreateEditTripPage()),
        CreateEditOrderPage.name:
            PageInfo(CreateEditOrderPage.name, () => CreateEditOrderPage()),
      };

  static List<String> get unAuthPages => [
        for (PageInfo page in pages.values)
          if (page.isUnAuth) page.route
      ];

  static List<String> get unHaveUserPages => [loading.route, setupUser.route];

  static PageInfo get loading => pages[LoadingPage.name]!;
  static PageInfo get setupUser => pages[SetupUserPage.name]!;
  static PageInfo get login => pages[LoginPage.name]!;
  static PageInfo get home => pages[HomePage.name]!;
  static PageInfo get createEditTruck => pages[CreateEditTruckPage.name]!;
  static PageInfo get createEditDriver => pages[CreateEditDriverPage.name]!;
  static PageInfo get createEditClient => pages[CreateEditClientPage.name]!;
  static PageInfo get createEditPayload => pages[CreateEditPayloadPage.name]!;
  static PageInfo get createEditTrip => pages[CreateEditTripPage.name]!;
  static PageInfo get createEditOrder => pages[CreateEditOrderPage.name]!;

  static PageInfo initialPage = loading;
  static PageInfo onAuthPage = home;
  static PageInfo onUnAuth = login;
  static PageInfo onUnHaveUser = setupUser;

  static List<GetMiddleware> appMiddleWares = [AuthMiddleware()];
}
