import 'package:beda3a_v2/src/utils/m_datetime.dart';
import 'package:get/get.dart';

import '../src/consts/costs.dart';
import '../src/models/models.dart';
import '../src/utils/page_info.dart';
import 'database.service.dart';

class UserSetting extends SettingCollection<Map> {
  int? userId;
  String? password;
  bool isAuth;
  UIThemeMode themeMode;

  UserSetting(this.userId, this.password, this.isAuth, this.themeMode,
      MDateTime createdAt)
      : super(
          'user',
          {
            'user_id': userId,
            'password': password,
            'is_auth': isAuth,
            'theme_mode': '$themeMode',
          },
          createdAt,
        );

  Future<UserCollection?>? get realUser =>
      userId != null ? UserModel.find(userId!) : null;

  static UserSetting fromMap(Map data, MDateTime createdAt) => UserSetting(
        data['userId'],
        data['password'],
        data['is_auth'],
        UIThemeMode.fromString(data['theme_mode']),
        createdAt,
      );

  static UserSetting fromCollection(SettingCollection<Map> collection) =>
      fromMap(collection.data, collection.createdAt);

  static Future<UserSetting> load() async =>
      UserSetting.fromCollection((await SettingModel.find('user'))!);
}

class MainService extends GetxService {
  static Map<String, PageInfo> get pages => {};

  UserSetting? userSetting;
  UserCollection? realUser;
  bool get isAuth => userSetting != null ? userSetting!.isAuth : false;

  UIThemeMode get themeMode =>
      userSetting != null ? userSetting!.themeMode : UIThemeMode.light;

  Future fastInit() async {
    DatabaseService databaseService = Get.put(DatabaseService());
    await databaseService.initDatabase();
    userSetting = await UserSetting.load();
  }

  PageInfo next() {
    if (userSetting!.userId == null) {
      return PagesInfo.onUnHaveUser;
    } else if (userSetting!.isAuth) {
      return PagesInfo.home;
    } else {
      return PagesInfo.login;
    }
  }

  Future setupUser(int userId, String password) {
    userSetting!.userId = userId;
    userSetting!.password = password;
    userSetting!.isAuth = true;
    return userSetting!.save();
  }

  Future onAuth() {
    userSetting!.isAuth = true;
    return userSetting!.save();
  }

  Future logout() {
    userSetting!.isAuth = false;
    return userSetting!.save();
  }
}
