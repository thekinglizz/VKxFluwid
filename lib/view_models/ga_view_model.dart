import 'package:flapp_widget/models/composited_category.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/venue.dart';
import 'action_view_model.dart';

final categoriesProvider = NotifierProvider<GeneralAdmissionState,
    Map<int, List<CompositedCategory>>>(() {
  return GeneralAdmissionState();
});

class GeneralAdmissionState extends Notifier<Map<int, List<CompositedCategory>>>{
  Map<int, List<CompositedCategory>> cMap = {};

  @override
  Map<int, List<CompositedCategory>> build() {
    Venue venue = ref.watch(asyncActionProvider
        .select((avm) => avm.value!.selectedVenue)); // подключаем провайдер представления, чтобы получить данные и состояние текущей венью
    for (var actionEvent in venue.actionEventList){
      cMap[actionEvent.actionEventId] = [];
      List<dynamic> tariffPlanList = actionEvent.tariffPlanList;
      for (var categoryLimit in actionEvent.categoryLimitList){
        if (categoryLimit.remainder is int){
          CompositedCategory tParent = CompositedCategory(categoryPriceId: null,
              price: null, categoryPriceName: '', parent: null,
              capacity: categoryLimit.remainder as int);
          for (var category in categoryLimit.categoryList){
            if (category.tariffIdMap!.isNotEmpty){
              List<Tariff> tariffs = [];
              for (var element in category.tariffIdMap!.entries){
                tariffs.add(Tariff(id: element.key, price: element.value,
                    name: tariffPlanList
                        .firstWhere((plan)=> plan['tariffPlanId'] == element.key)['tariffPlanName']));
              }
              cMap[actionEvent.actionEventId]!.add(CompositedTariffCategory(category.categoryPriceId,
                  category.price, category.categoryPriceName, tParent,
                  category.availability, tariffs));

            } else {
              cMap[actionEvent.actionEventId]!.add(CompositedCategory(categoryPriceId: category.categoryPriceId,
                  price: category.price, categoryPriceName: category.categoryPriceName,
                  parent: tParent, capacity: category.availability));
            }
          }
        } else {
          for (var category in categoryLimit.categoryList){
            if (category.tariffIdMap!.isNotEmpty){
              List<Tariff> tariffs = [];
              for (var element in category.tariffIdMap!.entries){
                tariffs.add(Tariff(id: element.key, price: element.value,
                    name: tariffPlanList
                        .firstWhere((plan)=> plan['tariffPlanId'] == element.key)['tariffPlanName']));
              }
              cMap[actionEvent.actionEventId]!.add(CompositedTariffCategory(category.categoryPriceId,
                  category.price, category.categoryPriceName, null,
                  category.availability, tariffs));
            } else {
              cMap[actionEvent.actionEventId]!.add(CompositedCategory(categoryPriceId: category.categoryPriceId,
                  price: category.price, categoryPriceName: category.categoryPriceName,
                  parent: null, capacity: category.availability));
            }
          }
        }
      }
    }
    return cMap;
  }

  void increaseCategory(int categoryPriceId, Tariff? tariff) {
    List<CompositedCategory> allCategories = state.values.expand((l) => l).toList();
    CompositedCategory category = allCategories.firstWhere((c) => c.categoryPriceId == categoryPriceId);

    if (tariff == null) {
      category.increment(ref);
    } else {
      (category as CompositedTariffCategory).incrementT(tariff, ref);
    }

    state = Map.of(state);
  }

  void decreaseCategory(int categoryPriceId, Tariff? tariff){
    List<CompositedCategory> allCategories = state.values.expand((l) => l).toList();
    CompositedCategory category = allCategories.firstWhere((c) => c.categoryPriceId == categoryPriceId);

    if (tariff == null) {
      category.decrement(ref);
    } else {
      (category as CompositedTariffCategory).decrementT(tariff, ref);
    }

    state = Map.of(state);
  }

  void decrementReservedTicket(int categoryPriceId) {
    List<CompositedCategory> allCategories = state.values.expand((l) => l).toList();
    CompositedCategory category = allCategories.firstWhere((c) => c.categoryPriceId == categoryPriceId);
    category.decrementReserved();

    state = Map.of(state);
  }

  void clearTicketReservation() {
    List<CompositedCategory> cList = state.values.toList().expand((l) => l).toList();
    for (var category in cList) {
      category.resetReserved(ref);
    }
    state = Map.of(state);
  }

  void clearUserSelection(){
    List<CompositedCategory> cList = state.values.toList().expand((l) => l).toList();
    for (var category in cList) {
      category.resetSelected(ref);
    }
    state = Map.of(state);
  }
}