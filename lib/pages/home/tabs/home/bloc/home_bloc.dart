import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../src/src.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeInitState()) {
    on<HomeEvent>((event, emit) async {
      // loading() => emit(const HomeLoadingState());
      // loaded<T>({T? data}) => emit(HomeLoadedState<T>(data: data));

      // if (event is LoadTrucksHomeEvent) {
      //   loading();
      //   loaded<List<TruckCollection>>(data: await TruckModel.all());
      // }
    });
  }
}
