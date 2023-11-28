import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'services/main.service.dart';
import 'src/consts/costs.dart';
import 'src/utils/utils.dart';

void main() async {
  await Get.put(MainService()).fastInit();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => GetMaterialApp(
        title: Consts.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: Consts.fontFamily,
          primaryColor: UIColors.primary1,
          backgroundColor: UIColors.primary1,
          useMaterial3: false,
        ),
        getPages: RouteManager.pages,
        initialRoute: PagesInfo.initialPage.route,
      );
}
