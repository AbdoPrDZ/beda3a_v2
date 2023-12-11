import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../consts/costs.dart';

abstract class MPage<T extends GetxController> extends StatefulWidget {
  final T? controller;

  // late PageStatus pageStatus;
  const MPage({
    Key? key,
    this.controller,
    // this.pageStatus = PageStatus.loaded,
  }) : super(key: key);

  Widget? buildDrawer() => null;
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;
  Widget? buildFloatingActionButton(BuildContext context) => null;

  Widget? bottomNavigationBar() => null;

  GlobalKey<ScaffoldState>? get scaffoldKey => null;

  @protected
  Widget buildBody(BuildContext context);

  Widget _build(BuildContext context) {
    Widget builder() => Scaffold(
          key: scaffoldKey,
          drawer: buildDrawer(),
          backgroundColor: UIThemeColors.pageBackground,
          bottomNavigationBar: bottomNavigationBar(),
          appBar: buildAppBar(context),
          body:
              // pageStatus.isLoading
              //     ? buildLoading(context)
              //     :
              SizedBox.expand(child: buildBody(context)),
          floatingActionButton: buildFloatingActionButton(context),
        );

    return controller == null
        ? builder()
        : GetBuilder<T>(
            init: controller,
            builder: (controller) => builder(),
          );
  }

  void initState() {}

  void dispose() {}

  // Widget buildLoading(BuildContext context) =>
  //     const Center(child: CircularProgressIndicator());

  @override
  State<MPage> createState() => _MPageState();
}

class _MPageState extends State<MPage> {
  @override
  initState() {
    widget.initState();
    super.initState();
    // widget.setPageHeaders(PageHeaders());
  }

  @override
  void dispose() {
    widget.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget._build(context);
}

enum PageStatus {
  loading,
  done;

  bool get isLoading => this == loading;
  bool get isDone => this == done;
}
