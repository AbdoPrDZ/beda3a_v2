import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CubitWidget<CubitT extends Cubit<StateT>, StateT>
    extends StatefulWidget {
  final CubitT Function(BuildContext context) getCubit;

  const CubitWidget({super.key, required this.getCubit});

  @protected
  Widget buildWidget(BuildContext context);

  Widget _build(BuildContext context) => BlocProvider<CubitT>(
        create: getCubit,
        child: buildWidget(context),
      );

  void initState(BuildContext context) {}

  void dispose() {}

  @override
  State<CubitWidget> createState() => _CubitWidgetState();
}

class _CubitWidgetState extends State<CubitWidget> {
  @override
  initState() {
    widget.initState(context);
    super.initState();
  }

  @override
  void dispose() {
    widget.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget._build(context);
}
