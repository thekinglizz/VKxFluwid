import 'package:flapp_widget/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/action.dart';
import '../models/action_event.dart';
import '../models/venue.dart';
import '../services/api_client.dart';

final asyncActionProvider = AsyncNotifierProvider<AVMState, ActionViewModel>(() {
  return AVMState();
});

class ActionRepository{
  Future<ActionViewModel> getActionViewModel() async{
    //Логика получения фида и токена
    fid = 1271;
    token = '7c696b4af364928202dd';

    final action = await ActionAPI.fetchAction();

    late Venue preferredVenue;
    late ActionEvent preferredActionEvent;

    //выбираем нужный сеанс и его площадку из данных о представлении
    for (var venue in (action.venueList as List<Venue>)){
      for (ActionEvent ae in venue.actionEventList){
        if (ae.actionEventId == int.parse(actionEventId)){
          preferredActionEvent = ae;
          preferredVenue = venue;
        }
      }
    }

    final avm = ActionViewModel(actionExt: action, selectedVenue: preferredVenue,
        selectedActionEvent: preferredActionEvent);

    return avm;
  }
}

class ActionViewModel {
  ActionViewModel({required this.actionExt,
    required this.selectedVenue, required this.selectedActionEvent, this.selectedDate});
  final Action actionExt;
  final Venue selectedVenue;
  final ActionEvent? selectedActionEvent;
  final DateTime? selectedDate;

  @override
  String toString() {
    return 'ActionViewModel{selectedVenue: $selectedVenue, '
        'selectedActionEvent: $selectedActionEvent}';
  }

  ActionViewModel copyWith({
    Action? actionExt,
    int? venueIdFromCityMode,
    Venue? selectedVenue,
    ActionEvent? selectedActionEvent,
    DateTime? selectedDate,
    List<int>? cityModeParameters
  }) {
    return ActionViewModel(
      actionExt: actionExt ?? this.actionExt,
      selectedVenue: selectedVenue ?? this.selectedVenue,
      selectedActionEvent: selectedActionEvent ?? this.selectedActionEvent,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }
}

class AVMState extends AsyncNotifier<ActionViewModel>{
  @override
  Future<ActionViewModel> build() async{
    return ActionRepository().getActionViewModel();
  }

  selectVenue(Venue tempVenue) {
    state = AsyncValue.data(state.value!.copyWith(selectedVenue: tempVenue,
          selectedActionEvent: tempVenue.actionEventList.first));
  }

  selectActionEvent(dynamic tempActionEvent) {
    state = AsyncValue.data(state.value!.copyWith(selectedActionEvent: tempActionEvent));
  }

  selectDay(DateTime date) {
    state = AsyncValue.data(state.value!.copyWith(selectedDate: date));
  }
}
