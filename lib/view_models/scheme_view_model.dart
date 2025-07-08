import 'dart:async';

import 'package:flapp_widget/view_models/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants.dart';
import '../models/scheme_models/assigned_seats_model.dart';
import '../models/scheme_models/category_price_model.dart';
import '../models/user.dart';
import '../services/api_client.dart';
import '../ui/widgets/scheme_widgets/seat_widget.dart';
import 'action_view_model.dart';

final asyncSchemeProvider = AsyncNotifierProvider<SVMState, SchemeViewModel>(() {
  return SVMState();
});

class SchemeRepository{
  Future<SchemeViewModel> getSchemeViewModel(ActionViewModel avm) async{
    final AssignedSeatsProcessor schemeData = await ActionAPI.computeSchemeData(avm
        .selectedActionEvent!.actionEventId, avm.selectedActionEvent!.placementUrl!);
    schemeData.getSectorScaffoldList();
    //определяем уже выбранные места пользователя
    List<Seat> sList = [];
    totalSum.value = 0;
    for (var sector in schemeData.sectorList) {
      for (var s in schemeData.siData.userSeatIdList){
        if (sector.seatList.any((seat)=>seat.bil24seatObj.seatId == s)){
          Seat tempSeat = sector.seatList.firstWhere((seat)=>seat.bil24seatObj.seatId == s);
          sList.add(tempSeat);
          if (tempSeat.category.tariffIdMap.isEmpty){
            totalSum.value += tempSeat.category.price;
          }
        }
      }
    }
    final svm = SchemeViewModel(
        schemeData: schemeData,
        selectedSeats: sList,
        categoryPriceFilter: null,
        selectedTariffSeats: {});

    // send post message
    PostMessageService.loadedEvent();

    return svm;
  }
}

class SchemeViewModel {
  final AssignedSeatsProcessor schemeData;
  final List<Seat> selectedSeats;
  final CategoryPriceObj? categoryPriceFilter;
  final Map<Seat, int> selectedTariffSeats;
  SchemeViewModel({required this.schemeData,
    required this.selectedSeats,
    this.categoryPriceFilter,
    required this.selectedTariffSeats});

  @override
  String toString() {
    return 'SchemeViewModel{schemeData: $schemeData, '
        'selectedSeats: $selectedSeats selectedCategoryPriceFilter: ${categoryPriceFilter?.id}}';
  }

  SchemeViewModel copyWith({
    AssignedSeatsProcessor? schemeData,
    List<Seat>? selectedSeats,
    CategoryPriceObj? categoryPriceFilter,
    Map<Seat, int>? selectedTariffSeats,
  }) {
    return SchemeViewModel(
      schemeData: schemeData ?? this.schemeData,
      selectedSeats: selectedSeats ?? this.selectedSeats,
      categoryPriceFilter: categoryPriceFilter,
      selectedTariffSeats: selectedTariffSeats ?? this.selectedTariffSeats,
    );
  }
}

class SVMState extends AsyncNotifier<SchemeViewModel>{
  @override
  Future<SchemeViewModel> build() {
    final action = ref.watch(asyncActionProvider).value;
    return SchemeRepository().getSchemeViewModel(action as ActionViewModel);
  }

  Future<dynamic> reserveSeat(Seat seat, User user, BuildContext context, String? fanId) async{
    List<Seat> userSeatList = state.value!.selectedSeats;
    dynamic reservationResult = await CartAPI.reserveSeats('RESERVE', user,
        seat.bil24seatObj.seatId, null, null, fanId);

    if (reservationResult is int){
      userSeatList.add(seat);
      ref.read(asyncUserProvider.notifier).incrementTotalSeatsInReserve();
      totalSum.value += seat.category.price;
      state = AsyncValue.data(state.value!.copyWith(selectedSeats: userSeatList,
          categoryPriceFilter: state.value!.categoryPriceFilter));
    }

    if (reservationResult is String){
      if (context.mounted){
        await showDialog<String>(
            context: context,
            builder: (BuildContext context) {
              return UserDialog(userMessage: reservationResult.toString(),
                  redirectFlag: false);
            });
      }
    }
  }

  Future<dynamic>  reserveSeatWithTariff(Seat seat, User user, BuildContext context,
      int tariffId, double expectedPrice, String? fanId) async{
    List<Seat> userSeatList = state.value!.selectedSeats;
    Map<Seat, int> tariffMap = state.value!.selectedTariffSeats;

    if(tariffMap.containsKey(seat)){
      totalSum.value -= seat.category.tariffIdMap[tariffMap[seat]]!;
      userSeatList.remove(seat);
      ref.read(asyncUserProvider.notifier).decrementTotalSeatsInReserve();
      await CartAPI.reserveSeats('UN_RESERVE', user, seat.bil24seatObj.seatId, null, null, null);
    }

    tariffMap[seat] = tariffId;
    dynamic reservationResult = await CartAPI.reserveSeats('RESERVE', user,
        seat.bil24seatObj.seatId, tariffId, expectedPrice, fanId);

    if (reservationResult is int){
      userSeatList.add(seat);
      totalSum.value += expectedPrice;
      ref.read(asyncUserProvider.notifier).incrementTotalSeatsInReserve();
      state = AsyncValue.data(state.value!.copyWith(selectedSeats: userSeatList,
        selectedTariffSeats: tariffMap, categoryPriceFilter: state.value!.categoryPriceFilter ));
    }

    if (reservationResult is String){
      if (context.mounted){
        await showDialog<String>(
            context: context,
            builder: (BuildContext context) {
              return UserDialog(userMessage: reservationResult.toString(),
                  redirectFlag: false);
            });
      }
    }
  }

  dynamic unreserveSeat(Seat seat, User user, double? expectedPrice) async{
    ref.read(asyncUserProvider.notifier).decrementTotalSeatsInReserve();
    if (expectedPrice is double){
      totalSum.value -= expectedPrice;
    } else {
      totalSum.value -= seat.category.price;
    }
    unselectSeatOnScheme(seat.bil24seatObj.seatId);
    await CartAPI.reserveSeats('UN_RESERVE', user, seat.bil24seatObj.seatId, null, null, null);
  }

  void unselectSeatOnScheme(int seatId){
    List<Seat> userSeatList = state.value!.selectedSeats;
    Map<Seat, int> tempMap = state.value!.selectedTariffSeats;
    userSeatList.removeWhere((element) => element.bil24seatObj.seatId == seatId);
    tempMap.removeWhere((key, value)=> key.bil24seatObj.seatId == seatId);
    state = AsyncValue.data(state.value!.copyWith(selectedSeats: userSeatList,
        selectedTariffSeats: tempMap, categoryPriceFilter: state.value!.categoryPriceFilter));
  }

  void clearSelectedSeats(){
    state = AsyncValue.data(state.value!.copyWith(selectedSeats: [],
        selectedTariffSeats: {}));
  }

  void filterCategories(CategoryPriceObj? category){
    state = AsyncValue.data(state.value!.copyWith(categoryPriceFilter: category));
  }
}