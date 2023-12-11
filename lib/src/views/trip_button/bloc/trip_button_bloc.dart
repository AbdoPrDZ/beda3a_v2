import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../pages/create_edit_trip/controller.dart';
import '../../../src.dart';

part 'trip_button_event.dart';
part 'trip_button_state.dart';

class TripButtonBloc extends Bloc<TripButtonEvent, TripButtonState> {
  final int truckId;
  TruckCollection? truck;
  TripBtnAnimationController? animationController;

  TripButtonBloc(this.truckId) : super(const TripButtonInitialState()) {
    on<TripButtonEvent>((event, emit) async {
      Future animate(String type) {
        emit(AnimatingState(type, animationController: animationController));
        return animationController!.animate(
          duration: const Duration(seconds: 1),
        );
      }

      if (event is LoadTruckEvent) {
        animationController = TripBtnAnimationController(vsync: event.vsync);
        truck = await TruckModel.find(truckId);
      } else {
        try {
          if (event is CreateTripEvent) {
            print("Create Trip");
            await RouteManager.to(
              PagesInfo.createEditTrip,
              arguments: CreateEditTripData(truckId: truckId),
            );
            await animate('create_trip');
          } else if (event is StartTripEvent) {
            print("Start Trip");
            await truck!.startCurrentTrip();
            await animate('start_trip');
          } else if (event is EndTripEvent) {
            print("End Trip");
            await truck!.endCurrentTrip();
            await animate('end_trip');
          } else if (event is DoneTripEvent) {
            print("Done Trip");
            await truck!.doneCurrentTrip();
          } else if (event is EditTripEvent) {
            print("Edit Trip");
            await RouteManager.to(
              PagesInfo.createEditTrip,
              arguments: CreateEditTripData(
                tripId: truck!.currentTrip!.id,
                action: CreateEditPageAction.edit,
              ),
            );
          }
        } catch (e) {
          emit(ErrorState('$e'));
          await Future.delayed(const Duration(seconds: 3));
        }
        truck = await TruckModel.find(truckId);
        emit(
          TripButtonState.getInitialState(
            truck?.currentTrip,
            animationController!,
          ),
        );
      }
    });
  }
}

class AnimationTimer {
  final Duration animationDuration;
  final Duration updateDuration;

  const AnimationTimer({
    required this.animationDuration,
    this.updateDuration = const Duration(seconds: 1),
  });

  Future start(Function(Duration currentDuration, double progress) onUpdate) {
    Duration currentDuration = const Duration();
    Completer completer = Completer();
    Timer.periodic(updateDuration, (timer) {
      onUpdate(
        currentDuration,
        currentDuration.inMicroseconds / animationDuration.inMicroseconds,
      );
      currentDuration += updateDuration;
      if (currentDuration > animationDuration) {
        timer.cancel();
        completer.complete();
      }
    });
    return completer.future;
  }
}

class TripBtnAnimationController extends AnimationController {
  TripBtnAnimationController({required super.vsync}) : super(value: 0);

  TickerFuture animate({Duration? duration, Curve curve = Curves.linear}) {
    value = 0;
    return super.animateTo(1, duration: duration, curve: curve);
  }

  double get valueRev => 1 - value;

  @override
  TickerFuture animateTo(double target,
          {Duration? duration, Curve curve = Curves.linear}) =>
      throw Exception("You don't allowed to use this method");
}
