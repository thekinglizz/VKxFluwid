import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../view_models/user_view_model.dart';

class Tariff {
  final int id;
  final double price;
  final String name;
  Tariff({required this.id, required this.price, required this.name});

  @override
  String toString() {
    return "[$id, $name]";
  }
}

class CompositedCategory {
  final int? categoryPriceId;
  final double? price;
  final String? categoryPriceName;
  final CompositedCategory? parent;
  int capacity;
  int selected; // кол-во выбранных билетов в виджете
  int reserved; // кол-во выбранных билетов в корзине

  CompositedCategory({
    required this.categoryPriceId,
    required this.price,
    required this.categoryPriceName,
    required this.parent,
    required this.capacity
  })
    : selected = 0,
      reserved = 0;

  bool hasAvailable() => available() > 0;

  int available() {
    int currentAvailable = capacity - max(reserved, selected);
    if (parent != null) {
      return min(parent!.available(), currentAvailable);
    }
    return currentAvailable;
  }

  void increment(Ref ref) {
    if (hasAvailable()) {
      if (parent != null) {
        if (parent!.hasAvailable()) {
          parent!.increment(ref);
        } else {return;}
      } else {
        ref.read(asyncUserProvider.notifier).incrementTotalSeatsInReserve();
      }
      ++selected;
      ++reserved;
    }
  }

  void decrement(Ref ref) {
    if (selected > 0) {
      if (parent != null) {
        parent!.decrement(ref);
      } else {
        ref.read(asyncUserProvider.notifier).decrementTotalSeatsInReserve();
      }
      --selected;
      --reserved;
    }
  }

  // TODO(iemasenko): для удаления конкретного билета из корзины
  void decrementReserved() {
    if (reserved > 0) {
      if (parent != null) {
        parent!.decrementReserved();
      }
      --reserved;
    }
  }

  void resetSelected(Ref ref) {
    selected = 0;
    if (parent != null) {
      parent!.resetSelected(ref);
    }
  }

  // TODO(iemasenko): для сброса всей корзины
  void resetReserved(Ref ref) {
    reserved = 0;
    if (parent != null) {
      parent!.resetReserved(ref);
    }
    resetSelected(ref);
  }

  @override
  String toString() {
    return 'CompositedCategory{categoryPriceId: $categoryPriceId, price: $price,'
        ' categoryPriceName: $categoryPriceName, parent: $parent,'
        ' capacity: $capacity, _selected: $selected}';
  }
}

class CompositedTariffCategory extends CompositedCategory {
  Map<Tariff, int> tariffsSelection = {};

  CompositedTariffCategory(int id, double price, String name, CompositedCategory? parent,
      int capacity, List<Tariff> tariffs) : super(categoryPriceId: id, price: price,
      categoryPriceName: name, parent: parent, capacity: capacity) {
    for (final Tariff t in tariffs) {
      tariffsSelection[t] = 0;
    }
  }

  void incrementT(Tariff t, Ref ref) {
    if (hasAvailable()) {
      increment(ref);
      tariffsSelection[t] = tariffsSelection[t]! + 1;
    }
  }

  void decrementT(Tariff t, Ref ref) {
    if (tariffsSelection[t] != null && tariffsSelection[t]! > 0 && selected > 0) {
      decrement(ref);
      tariffsSelection[t] = tariffsSelection[t]! - 1;
    }
  }

  @override
  void resetSelected(Ref ref) {
    tariffsSelection.updateAll((_, value) => value = 0);
    super.resetSelected(ref);
  }

  @override
  String toString() {
    return 'CompositedTariffCategory{id: $categoryPriceId, name: $categoryPriceName, '
        'parent: $parent, capacity: $capacity,tariffsInfo: $tariffsSelection}';
  }
}
