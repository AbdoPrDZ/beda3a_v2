import 'package:flutter_bloc/flutter_bloc.dart';

import '../../src.dart';
import 'bloc/trip_button_bloc.dart';

class TripButtonView
    extends BlocWidget<TripButtonBloc, TripButtonEvent, TripButtonState> {
  final int truckId;
  final double? width;
  final double height;
  final EdgeInsets margin;

  TripButtonView({
    required this.truckId,
    this.width,
    this.height = 150,
    this.margin = const EdgeInsets.symmetric(vertical: 10),
    super.key,
  }) : super(
          getBloc: (context) => TripButtonBloc(truckId),
          withTrickProvider: true,
        );

  // TripBtnAnimationController? animationController;

  // @override
  // void initState(BuildContext context, {TickerProvider? vsync}) {
  //   vsync = vsync;
  //   animationController = TripBtnAnimationController(vsync: vsync!);
  //   super.initState(context, vsync: vsync);
  // }

  // @override
  // void dispose() {
  //   animationController?.stop();
  //   animationController?.dispose();
  //   super.dispose();
  // }

  Text _buildDateTimeText(MDateTime? dateTime) => Text(
        '$dateTime'.replaceAll(' ', '\n'),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: UIThemeColors.text3,
          fontSize: 10,
        ),
      );

  @override
  Widget buildWidget(BuildContext context, {TickerProvider? vsync}) {
    double width = this.width ?? MediaQuery.of(context).size.width;
    return BlocBuilder<TripButtonBloc, TripButtonState>(
      builder: (context, state) {
        if (state is TripButtonInitialState) {
          callEvent(context, LoadTruckEvent(vsync!));
        }
        return state is LoadingState || state is TripButtonInitialState
            ? const CircularProgressIndicator(color: Colors.white)
            :
            // animationController == null ||
            state is ErrorState
                ? Text(
                    // state is ErrorState ?
                    state.errorMsg
                    // : 'Some things wrong !!?'
                    ,
                    style: TextStyle(
                      color: UIThemeColors.danger,
                      fontSize: 20,
                    ),
                  )
                : Container(
                    width: width,
                    height: height,
                    margin: margin,
                    child: AnimatedBuilder(
                      animation: state.animationController!,
                      builder: (BuildContext context, Widget? child) {
                        double height =
                            state.showEditBtn ? this.height - 40 : this.height;

                        // Button Parameters
                        double btnSize = 120;
                        double btnCenter = width / 2 - (btnSize / 2);
                        double btnLeft = btnCenter;
                        if (state is AnimatingState) {
                          if (state.type == 'create_trip') {
                            btnLeft = (btnCenter - 10) *
                                    state.animationController!.valueRev +
                                10;
                            btnSize =
                                70 * state.animationController!.valueRev + 50;
                          } else if (state.type == 'start_trip') {
                            btnSize = 50;
                            btnLeft = (width - btnSize - 10) *
                                    state.animationController!.value +
                                10;
                          } else if (state.type == 'end_trip') {
                            btnSize =
                                70 * state.animationController!.value + 50;
                            btnLeft = (width - btnSize - 10 - btnCenter) *
                                    state.animationController!.valueRev +
                                btnCenter;
                          }
                        } else if (state is TripCreatedState) {
                          btnLeft = 10;
                          btnSize = 50;
                        } else if (state is TripStartedState) {
                          btnSize = 50;
                          btnLeft = width - btnSize - 10;
                        } else if (state is TripEndedState) {
                          btnLeft = btnCenter;
                          btnSize = 120;
                        }
                        double btnTop = height / 2 - (btnSize / 2);

                        // Progress Parameters
                        double proWidth = 0;
                        double proHeight = 15;
                        if (state is AnimatingState &&
                            state.type == 'create_trip') {
                          proWidth =
                              (width * 0.68) * state.animationController!.value;
                        } else {
                          proWidth = width * 0.68;
                        }
                        double proLeft = width / 2 - (proWidth / 2);
                        double proTop = height / 2 - (proHeight / 2);

                        double cProLeft = proLeft + 2;
                        double cProWidth = 0;
                        double cProHeight = 12;
                        if (state is AnimatingState &&
                            state.type == 'start_trip') {
                          cProWidth = (width * 0.68 - 4) *
                              state.animationController!.value;
                        } else if (state is TripStartedState) {
                          cProWidth = width * 0.68 - 4;
                        }
                        double cProTop = height / 2 - (cProHeight / 2);

                        // Build
                        return Stack(
                          children: [
                            if (state.showProgress) ...[
                              Positioned(
                                left: proLeft,
                                top: proTop,
                                width: proWidth,
                                height: proHeight,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: UIThemeColors.field,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: cProLeft,
                                top: cProTop,
                                width: cProWidth,
                                height: cProHeight,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: UIThemeColors.primary,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: proTop + proHeight + 5,
                                left: proLeft,
                                child: state.trip?.startAt == null
                                    ? StreamBuilder(
                                        stream: MDateTime.streamNow(),
                                        builder: (context, snapshot) =>
                                            _buildDateTimeText(snapshot.data),
                                      )
                                    : _buildDateTimeText(state.trip!.startAt!),
                              ),
                              Positioned(
                                top: proTop + proHeight + 5,
                                left: proLeft + proWidth / 2 - 18,
                                child: state.trip != null &&
                                        state.trip!.startAt != null &&
                                        state.trip!.endAt == null
                                    ? StreamBuilder(
                                        stream: MDateTime.streamNow(),
                                        builder: (context, snapshot) =>
                                            _buildDateTimeText(snapshot.data
                                              ?..setFormat('HH:mm:ss')),
                                      )
                                    : state.trip?.startAt != null &&
                                            state.trip?.endAt != null
                                        ? _buildDateTimeText(
                                            (state.trip!.startAt! -
                                                state.trip!.endAt!)
                                              ..setFormat('HH:mm:ss'),
                                          )
                                        : _buildDateTimeText(
                                            MDateTime.zero
                                              ..setFormat('HH:mm:ss'),
                                          ),
                              ),
                              Positioned(
                                top: proTop + proHeight + 5,
                                left: proLeft + proWidth - 40,
                                child: state.trip?.endAt == null
                                    ? StreamBuilder(
                                        stream: MDateTime.streamNow(),
                                        builder: (context, snapshot) =>
                                            _buildDateTimeText(snapshot.data),
                                      )
                                    : _buildDateTimeText(state.trip!.endAt!),
                              ),
                            ],
                            if (state.showEditBtn)
                              Positioned(
                                left: width / 2 - 25,
                                bottom: 0,
                                width: 50,
                                height: 50,
                                child: CirclerButtonView.icon(
                                  Icons.edit,
                                  onPressed: () {
                                    callEvent(
                                      context,
                                      const EditTripEvent(),
                                    );
                                  },
                                  iconColor: Colors.white,
                                  backgroundColor: UIColors.warning,
                                ),
                              ),
                            Positioned(
                              left: btnLeft,
                              top: btnTop,
                              child: CirclerButtonView(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  if (state is NoTripCreatedState) {
                                    callEvent(
                                      context,
                                      const CreateTripEvent(),
                                    );
                                  } else if (state is TripCreatedState) {
                                    callEvent(
                                      context,
                                      const StartTripEvent(),
                                    );
                                  } else if (state is TripStartedState) {
                                    callEvent(
                                      context,
                                      const EndTripEvent(),
                                    );
                                  } else if (state is TripEndedState) {
                                    callEvent(
                                      context,
                                      const DoneTripEvent(),
                                    );
                                  }
                                },
                                size: btnSize,
                                backgroundColor: state.color,
                                child: state.buildChild(
                                  context,
                                  state.animationController!,
                                )!,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
      },
    );
  }
}
