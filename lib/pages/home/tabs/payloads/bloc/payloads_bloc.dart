import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../src/src.dart';
import '../../../../create_edit_payload/controller.dart';

part 'payloads_event.dart';
part 'payloads_state.dart';

class PayloadsBloc extends Bloc<PayloadsEvent, PayloadsState> {
  PayloadsBloc() : super(const PayloadsInitState()) {
    on<PayloadsEvent>((event, emit) async {
      loading() => emit(const PayloadsLoadingState());
      loaded(List<PayloadCollection> payloads) =>
          emit(PayloadsLoadedState(payloads));

      if (event is GetPayloadsEvent) {
        loading();
        loaded(await PayloadModel.allWhere());
      } else if (event is SearchPayloadsEvent) {
        loading();
        loaded(
          await PayloadModel.allWhere(where: event.getQuery()),
        );
      } else if (event is CreatePayloadEvent) {
        loading();
        await RouteManager.to(PagesInfo.createEditPayload);
        loaded(await PayloadModel.allWhere());
      } else if (event is EditPayloadEvent) {
        loading();
        await RouteManager.to(
          PagesInfo.createEditPayload,
          arguments: CreateEditPayloadData(
            action: CreateEditPageAction.edit,
            payloadId: event.payloadId,
          ),
        );
        loaded(await PayloadModel.allWhere());
      } else if (event is ClearPayloadEvent) {
        loading();
        await PayloadModel.clear();
        loaded(await PayloadModel.allWhere());
      }
    });
  }
}
