import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../consts/costs.dart';
import 'cubit_widget.dart';

abstract class CubitPage<CubitT extends Cubit<StateT>, StateT>
    extends CubitWidget<CubitT, StateT> {
  const CubitPage({super.key, required super.getCubit});

  GlobalKey<ScaffoldState>? get scaffoldKey => null;
  Widget? buildDrawer(BuildContext context) => null;
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;
  Widget? buildFloatingActionButton(BuildContext context) => null;
  Widget? bottomNavigationBar(BuildContext context) => null;

  @protected
  Widget buildBody(BuildContext context);

  @override
  Widget buildWidget(BuildContext context) => Scaffold(
        key: scaffoldKey,
        drawer: buildDrawer(context),
        backgroundColor: UIThemeColors.pageBackground,
        bottomNavigationBar: bottomNavigationBar(context),
        appBar: buildAppBar(context),
        body: SizedBox.expand(child: buildBody(context)),
        floatingActionButton: buildFloatingActionButton(context),
      );
}
