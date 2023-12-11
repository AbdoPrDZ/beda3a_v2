part of 'payloads_bloc.dart';

@immutable
sealed class PayloadsState {
  const PayloadsState();
}

class PayloadsInitState extends PayloadsState {
  const PayloadsInitState();
}

class PayloadsLoadingState extends PayloadsState {
  const PayloadsLoadingState();
}

class PayloadsLoadedState extends PayloadsState {
  final List<PayloadCollection> payloads;

  const PayloadsLoadedState(this.payloads);
}
