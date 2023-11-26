import 'package:flutter/material.dart';

import '../../src/consts/costs.dart';
import '../../src/utils/utils.dart' as utils;
import '../../src/views/views.dart';
import 'controller.dart';

class HomePage extends utils.Page<HomeController> {
  static const String name = '/home';

  HomePage({Key? key}) : super(controller: HomeController(), key: key);

  @override
  HomeController get controller => super.controller!;

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => AppBar(
        backgroundColor: UIThemeColors.primary,
        title: const Text('Login'),
      );

  @override
  Widget buildBody(BuildContext context) => Center(
        child: Text('Home'),
      );
}
