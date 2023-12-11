import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BlocWidget<BlocT extends Bloc<EventT, StateT>, EventT, StateT>
    extends StatefulWidget {
  final BlocT Function(BuildContext context) getBloc;
  final bool withTrickProvider;

  const BlocWidget({
    super.key,
    required this.getBloc,
    this.withTrickProvider = false,
  });

  @protected
  Widget buildWidget(BuildContext context, {TickerProvider? vsync});

  Widget _build(BuildContext context, {TickerProvider? vsync}) =>
      BlocProvider<BlocT>(
        create: getBloc,
        child: buildWidget(context, vsync: vsync),
      );

  void initState(BuildContext context, {TickerProvider? vsync}) {}

  void dispose() {}

  void callEvent(BuildContext context, EventT event) {
    BlocProvider.of<BlocT>(context).add(event);
  }

  @override
  State<BlocWidget> createState() => withTrickProvider
      ? _BlocWidgetStateWithTrickProvider()
      : _BlocWidgetState();
}

class _BlocWidgetState extends State<BlocWidget> {
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

class _BlocWidgetStateWithTrickProvider extends State<BlocWidget>
    with TickerProviderStateMixin {
  @override
  initState() {
    widget.initState(context, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    widget.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget._build(context, vsync: this);
}
