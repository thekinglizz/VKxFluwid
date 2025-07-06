import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

@JsonSerializable(explicitToJson: true)
class Category{
  final int categoryPriceId;
  final String categoryPriceName;
  final int availability;
  final double price;
  final Map<int, double>? tariffIdMap; //список тарифов, key - id тарифного плана, value - стоимость

  const Category({
    required this.categoryPriceId,
    required this.categoryPriceName,
    required this.availability,
    required this.price,
    this.tariffIdMap,
  });

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);

  @override
  String toString() {
    return 'Category{categoryPriceId: $categoryPriceId, '
        'categoryPriceName: $categoryPriceName, availability: $availability, '
        'price: $price, tariffIdMap: $tariffIdMap}';
  }
}

@JsonSerializable(explicitToJson: true)
class CategoryLimit{
  final int? remainder;
  final List<Category> categoryList;

  const CategoryLimit({
    required this.remainder,
    required this.categoryList,
  });

  factory CategoryLimit.fromJson(Map<String, dynamic> json) => _$CategoryLimitFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryLimitToJson(this);

  @override
  String toString() {
    return 'CategoryLimit{remainder: $remainder, categoryList: $categoryList}';
  }
}

class CategoryItem{
  final int categoryPriceId;
  final int quantity;
  final double expectedPrice;
  final int initialAvailability;
  final Map<int, int>? selectedTariffIdMap; //{tariffId : quantity}
  final Map<int, double>? expectedPriceForTariffPlans; // {tariffId : expectedPrice}
  int availability;

  CategoryItem({
    required this.categoryPriceId,
    required this.quantity,
    required this.expectedPrice,
    required this.initialAvailability,
    required this.availability,
    this.selectedTariffIdMap,
    this.expectedPriceForTariffPlans,
  });

  int sumOfMapValues(){
    int i = 0;
    for (var value in selectedTariffIdMap!.values){
      i += value;
    }
    return i;
  }

  @override
  String toString() {
    return 'CategoryItem{categoryId: $categoryPriceId, quantity: $quantity, '
        'expectedPrice: $expectedPrice, initialAvailability: $initialAvailability, '
        'availability: $availability, selectedTariffIdMap: $selectedTariffIdMap, '
        'expectedPriceForTariffPlans: $expectedPriceForTariffPlans}';
  }

  CategoryItem copyWith({
    int? categoryPriceId,
    int? quantity,
    double? expectedPrice,
    int? initialAvailability,
    int? availability,
    Map<int, int>? selectedTariffIdMap,
    Map<int, double>? expectedPriceForTariffPlans,
  }) {
    return CategoryItem(
      categoryPriceId: categoryPriceId ?? this.categoryPriceId,
      quantity: quantity ?? this.quantity,
      expectedPrice: expectedPrice ?? this.expectedPrice,
      initialAvailability: initialAvailability ?? this.initialAvailability,
      availability: availability ?? this.availability,
      selectedTariffIdMap: selectedTariffIdMap ?? this.selectedTariffIdMap,
      expectedPriceForTariffPlans:
          expectedPriceForTariffPlans ?? this.expectedPriceForTariffPlans,
    );
  }
}

class CategoryLimitItem{
  final int? initialRemainder;
  int? remainder;
  final List<CategoryItem> categoryItemList;

  CategoryLimitItem({
    this.initialRemainder,
    this.remainder,
    required this.categoryItemList,
  });

  @override
  String toString() {
    return 'CategoryLimitItem{initialRemainder: $initialRemainder, remainder: $remainder, '
        'categoryItemList: $categoryItemList}';
  }

  CategoryLimitItem copyWith({
    int? initialRemainder,
    int? remainder,
    List<CategoryItem>? categoryItemList,
  }) {
    return CategoryLimitItem(
      initialRemainder: initialRemainder ?? this.initialRemainder,
      remainder: remainder ?? this.remainder,
      categoryItemList: categoryItemList ?? this.categoryItemList,
    );
  }
}