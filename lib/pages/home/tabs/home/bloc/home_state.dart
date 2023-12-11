part of 'home_bloc.dart';

@immutable
sealed class HomeState {
  const HomeState();
}

class HomeInitState extends HomeState {
  const HomeInitState();
}

class HomeLoadingState extends HomeState {
  const HomeLoadingState();
}

class HomeLoadedState<T> extends HomeState {
  final T? data;

  const HomeLoadedState({this.data});
}
