import 'dart:ui';

class CategoryPriceObj{
  final int id;
  final String name;
  final Color color;
  final double price;
  final int availability;
  final bool placement;
  final Map<int, double> tariffIdMap; //список тарифов, key - id тарифного плана, value - стоимость

  CategoryPriceObj({required this.id, required this.name, required this.color,
    required this.price, required this. availability, required this.tariffIdMap,
  required this.placement});

  @override
  String toString() {
    return 'CategoryPriceObj{id: $id, name: $name, color: $color, price: $price,'
        ' availability: $availability, placement: $placement, tariffIdMap: $tariffIdMap}';
  }
}