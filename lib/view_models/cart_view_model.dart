import 'dart:async';

import 'package:flapp_widget/models/cart_models/cart.dart';
import 'package:flapp_widget/models/cart_models/visitor_data.dart';
import 'package:flapp_widget/services/api_client.dart';
import 'package:flapp_widget/view_models/ga_view_model.dart';
import 'package:flapp_widget/view_models/scheme_view_model.dart';
import 'package:flapp_widget/view_models/user_view_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';
import '../models/user.dart';

class CartRepository{
  Future<CartOrder> createCartOrder(Ref ref) async{
    final user = ref.read(asyncUserProvider).value;
    late final CartOrder cartOrder;
    if (user?.state == UserStates.authorized){
      cartOrder = await CartAPI.getCart(user as User);
    }
    //синхронизируем счетчик всех мест в корзине пользователя ответом от сервера
    int totalSeatsInReserve = 0;
    for (var element in cartOrder.bList) {
      totalSeatsInReserve += element.itemList.length;
    }
    if (totalSeatsInReserve > 0){
      ref.read(asyncUserProvider.notifier).setTotalSeatsInReserve(totalSeatsInReserve);
    }
    return cartOrder;
  }
}

class CartState extends AutoDisposeAsyncNotifier<CartOrder>{

  @override
  FutureOr<CartOrder> build(){
    return CartRepository().createCartOrder(ref);
  }

  void deleteSeat(int seatId, int categoryPriceId, User user, BuildContext context) async{
    late int cartTimeOut;
    final cartResponse = await CartAPI.reserveSeats('UN_RESERVE', user, seatId, null, null, null);
    if (cartResponse is int){
      cartTimeOut = cartResponse;
      late CartItem deletedItem;
      double newTotalServiceCharge = 0;
      double newTotalSum = 0;

      //Удаляем выбранное пользователем место
      for (var i in state.value!.bList){
        if (i.itemList.any((element) {
          return element.seatId == seatId;})){
          deletedItem = i.itemList.firstWhere((element) {
            return element.seatId == seatId;});
          i.itemList.remove(deletedItem);
          ref.read(asyncUserProvider.notifier).decrementTotalSeatsInReserve();
        }
      }

      //Удаляем карточки с пустыми сеансами и обнуляем сумму и сервисный сбор
      state.value!.bList.removeWhere((element)=> element.itemList.isEmpty);
      newTotalServiceCharge = 0;
      newTotalSum = 0;

      //высчитываем новую сумму и сервисный сбор оставшихся выбранных мест
      for (var i in state.value!.bList){
        newTotalServiceCharge += i.itemList
            .fold(0, (previousValue, element) => previousValue + element.serviceCharge.toInt());
        newTotalSum += i.itemList
            .fold(0, (previousValue, element) => previousValue + element.price.toInt());
      }

      //уменьшаем сумму-подсказку для мест на СХЕМЕ
      if (totalSum.value > 0){
        if (deletedItem.sector != null &&
            deletedItem.row != null &&
            deletedItem.number != null){
          totalSum.value -= deletedItem.price;
        }
      }

      if (ref.exists(asyncSchemeProvider)) {
        if (ref.read(asyncSchemeProvider).value!.selectedSeats.isNotEmpty){
          ref.read(asyncSchemeProvider.notifier).unselectSeatOnScheme(seatId);
        }
      }

      final categoriesMap = ref.read(categoriesProvider);
      if (categoriesMap.values.any((value)=>value.isNotEmpty)){
        if (categoriesMap.values.expand((l) => l).toList()
            .any((c)=>c.categoryPriceId == categoryPriceId)){
          ref.read(categoriesProvider.notifier).decrementReservedTicket(categoryPriceId);
        }
      }

      state = AsyncValue.data(state.value!.copyWith(
        totalServiceCharge: newTotalServiceCharge,
        totalSum: newTotalSum,
        time: cartTimeOut, currency: state.value!.currency,
        bList: state.value!.bList,
      ));
    }
    else {
      if (context.mounted){
        showDialog<String>(
          context: context,
          builder: (BuildContext context) =>
              UserDialog(userMessage: cartResponse.toString(), redirectFlag: false),
        );
      }
    }
  }

  void deleteAllSeats(int seatId, User user, BuildContext context){ //int нулевой
    late int cartTimeOut;
    totalSum.value = 0;
    CartAPI.reserveSeats('UN_RESERVE_ALL', user, seatId, null, null, null)
        .then((value) {
      if (value is int){
        cartTimeOut = value;
        if (ref.exists(asyncSchemeProvider)) {
          ref.read(asyncSchemeProvider.notifier).clearSelectedSeats();
        }
        ref.read(asyncUserProvider.notifier).clearTotalSeatsInReserve();

        ref.read(categoriesProvider.notifier).clearTicketReservation();

        state = AsyncValue.data(state.value!.copyWith(
            totalServiceCharge: 0,
            totalSum: 0, time: cartTimeOut, bList: [], currency: ''));
      } else {
        if (context.mounted){
          showDialog<String>(
            context: context,
            builder: (BuildContext context) =>
                UserDialog(userMessage:
                value.toString(), redirectFlag: false),
          );
        }
      }
    });
  }

  void clearCart(User user){
    if (ref.exists(asyncSchemeProvider)) {
      ref.read(asyncSchemeProvider.notifier).clearSelectedSeats();
    }
    ref.read(asyncUserProvider.notifier).clearTotalSeatsInReserve();
    state = AsyncValue.data(state.value!.copyWith(
        totalServiceCharge: 0,
        totalSum: 0, time: 0, bList: [],
        currency: ''));
  }

  void createOrder(User user){
    ref.read(asyncUserProvider.notifier).clearTotalSeatsInReserve();
    if (ref.exists(asyncSchemeProvider)) {
      ref.read(asyncSchemeProvider.notifier).clearSelectedSeats();
    }
    totalSum.value = 0;
    state = AsyncValue.data(state.value!.copyWith(
        totalServiceCharge: 0,
        totalSum: 0, time: 0, bList: state.value!.bList,
        currency: ''));
  }

  void updateCart(User user) async{
    final newCartOrder = await CartAPI.getCart(user);
    state = AsyncValue.data(state.value!.copyWith(
        totalServiceCharge: newCartOrder.totalServiceCharge,
        totalSum: newCartOrder.totalSum, time: newCartOrder.time,
        bList: newCartOrder.bList, currency: newCartOrder.currency));
  }

  void addVisitorData(VisitorData vd){
    final tempList = state.value!.vdList ?? [];
    if (tempList.any((element)=> element.seatId == vd.seatId)){
      tempList[tempList.indexWhere((element)=> element.seatId == vd.seatId)] = vd;
    } else {
      tempList.add(vd);
    }
    state = AsyncValue.data(state.value!.copyWith(vdList: tempList));
  }

  void clearVisitorData(int? seatId){
    final tempList = state.value?.vdList ?? [];
    if (seatId is int){
      if (tempList.any((element)=> element.seatId == seatId)){
        tempList.removeWhere((element)=> element.seatId == seatId);
      }
    } else {
      tempList.clear();
    }
    state = AsyncValue.data(state.value!.copyWith(vdList: tempList));
  }
}

final asyncCartProvider = AsyncNotifierProvider.autoDispose<CartState, CartOrder>(() {
  return CartState();
});

void launchFormURL(String uri) async =>
    await canLaunchUrl(Uri.parse(uri)) ?
    await launchUrl(Uri.parse(uri)) :
    throw 'Could not launch$uri';