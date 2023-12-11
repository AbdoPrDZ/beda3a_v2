part of 'trip_button_bloc.dart';

@immutable
sealed class TripButtonState {
  final TripBtnAnimationController? animationController;
  final TripCollection? trip;

  const TripButtonState({this.animationController, this.trip});

  Widget? buildChild(
    BuildContext context,
    TripBtnAnimationController animationController,
  ) =>
      null;

  Color? get color => null;

  bool get showEditBtn => true;
  bool get showProgress => true;

  static TripButtonState getInitialState(
    TripCollection? trip,
    TripBtnAnimationController animationController,
  ) {
    if (trip != null && trip.startAt == null) {
      return TripCreatedState(
        animationController: animationController,
        trip: trip,
      );
    } else if (trip != null && trip.startAt != null && trip.endAt == null) {
      return TripStartedState(
        animationController: animationController,
        trip: trip,
      );
    } else if (trip != null && trip.startAt != null && trip.endAt != null) {
      return TripEndedState(
        animationController: animationController,
        trip: trip,
      );
    } else {
      return NoTripCreatedState(animationController: animationController);
    }
  }
}

class TripButtonInitialState extends TripButtonState {
  const TripButtonInitialState();
}

class NoTripCreatedState extends TripButtonState {
  const NoTripCreatedState({super.animationController}) : super(trip: null);

  @override
  Widget? buildChild(
    BuildContext context,
    TripBtnAnimationController animationController,
  ) =>
      const Text(
        'Create',
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      );

  @override
  Color? get color => UIThemeColors.primary;

  @override
  bool get showEditBtn => false;

  @override
  bool get showProgress => false;
}

class TripCreatedState extends TripButtonState {
  const TripCreatedState({super.trip, super.animationController});

  @override
  Widget? buildChild(
    BuildContext context,
    TripBtnAnimationController animationController,
  ) =>
      const Icon(
        Icons.play_arrow,
        size: 30,
        color: Colors.white,
      );

  @override
  Color? get color => UIThemeColors.primary;
}

// class TripEditState extends TripButtonState {}

class TripStartedState extends TripButtonState {
  const TripStartedState({super.trip, super.animationController});

  @override
  Widget? buildChild(
    BuildContext context,
    TripBtnAnimationController animationController,
  ) =>
      const Icon(
        Icons.pause,
        size: 30,
        color: Colors.white,
      );

  @override
  Color? get color => UIThemeColors.danger;
}

class TripEndedState extends TripButtonState {
  const TripEndedState({super.trip, super.animationController});

  @override
  Widget? buildChild(
    BuildContext context,
    TripBtnAnimationController animationController,
  ) =>
      Icon(
        Icons.done,
        size: animationController.isAnimating
            ? 30 * animationController.value + 30
            : 60,
        color: Colors.white,
      );

  @override
  Color? get color => UIThemeColors.success;

  @override
  bool get showEditBtn => false;

  @override
  bool get showProgress => false;
}

class AnimatingState extends TripButtonState {
  final String type;

  const AnimatingState(
    this.type, {
    super.trip,
    super.animationController,
  });

  TripButtonState get toState => {
        'create_trip':
            TripCreatedState(animationController: animationController),
        'start_trip':
            TripStartedState(animationController: animationController),
        'end_trip': TripEndedState(animationController: animationController),
      }[type]!;

  @override
  Widget? buildChild(
    BuildContext context,
    TripBtnAnimationController animationController,
  ) =>
      toState.buildChild(context, animationController);

  @override
  Color? get color => toState.color;

  @override
  bool get showEditBtn => ['create_trip', 'start_trip'].contains(type);

  @override
  bool get showProgress => ['create_trip', 'start_trip'].contains(type);
}

class LoadingState extends TripButtonState {
  const LoadingState();
}

class ErrorState extends TripButtonState {
  final String errorMsg;

  const ErrorState(this.errorMsg, {super.animationController});
}
