import 'package:get/get.dart';

import '../src/src.dart';
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

  @override
  Future<int> save() {
    value = {
      'user_id': userId,
      'password': password,
      'is_auth': isAuth,
      'theme_mode': '$themeMode',
    };
    return super.save();
  }

  static UserSetting fromMap(Map data, MDateTime createdAt) => UserSetting(
        data['user_id'],
        data['password'],
        data['is_auth'],
        UIThemeMode.fromString(data['theme_mode']),
        createdAt,
      );

  static UserSetting fromCollection(SettingCollection<Map> collection) =>
      fromMap(collection.value!, collection.createdAt);

  static Future<UserSetting> load() async =>
      UserSetting.fromCollection((await SettingModel.find('user'))!);
}

class MainService extends GetxService {
  UserSetting? userSetting;
  UserCollection? realUser;

  bool get unHaveUser => userSetting?.userId == null;
  bool get isAuth => userSetting != null ? userSetting!.isAuth : false;
  UIThemeMode get themeMode =>
      userSetting != null ? userSetting!.themeMode : UIThemeMode.light;

  AppDatabase? get appDatabase => Get.find<DatabaseService>().appDatabase;

  Future fastInit() async {
    DatabaseService databaseService = Get.put(DatabaseService());
    await databaseService.initDatabase();
    userSetting = await UserSetting.load();
    print(userSetting);
  }

  Future<PageInfo> next() async {
    realUser = await (userSetting!.realUser);
    if (userSetting!.userId == null) {
      return PagesInfo.onUnHaveUser;
    } else if (userSetting!.isAuth) {
      return PagesInfo.home;
    } else {
      return PagesInfo.login;
    }
  }

  Future setupUser(UserCollection user, String password) async {
    userSetting!.userId = user.id;
    userSetting!.password = password;
    userSetting!.isAuth = true;
    realUser = await (userSetting!.realUser);
    await userSetting!.save();
  }

  Future onAuth() async {
    realUser = await (userSetting!.realUser);
    userSetting!.isAuth = true;
    await userSetting!.save();
  }

  Future logout() async {
    userSetting!.isAuth = false;
    await userSetting!.save();
    RouteManager.to(PagesInfo.login, clearHeaders: true);
  }

  Future setThemeMode(UIThemeMode themeMode) {
    userSetting!.themeMode = themeMode;
    Get.forceAppUpdate();
    return userSetting!.save();
  }
}
