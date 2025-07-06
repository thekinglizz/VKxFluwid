import 'package:flapp_widget/models/cart_models/visitor_data.dart';

class CartItem{
  final int price;
  final int seatId;
  final int categoryPriceId;
  final int? tariffPlanId;
  final double serviceCharge;
  final String categoryPriceName;
  final String day;
  final String time;
  final String currency;
  final String? sector;
  final String? row;
  final String? number;
  final String? tariffName;
  final String? discountReason;
  final List<VisitorData>? visitorDataList;

  CartItem({required this.categoryPriceName, required this.categoryPriceId,
    required this.day, required this.time, required this.price, required this.seatId,
    required this.currency, this.tariffName, this.tariffPlanId, required this.sector, required this.row,
    required this.number, required this.serviceCharge, this.discountReason,
    this.visitorDataList});

  @override
  String toString() {
    return 'CartItem{categoryPriceName: $categoryPriceName, day: $day, '
        'time: $time, price: $price, seatId: $seatId, serviceCharge: $serviceCharge, '
        'sector: $sector, row: $row, number: $number, currency: $currency, '
        'tariffName: $tariffName, discountReason: $discountReason}';
  }
}

class CartItemWrapper{
  final String actionName;
  final String venueName;
  final bool fullNameRequired;
  final bool phoneRequired;
  final bool fanIdRequired;
  final bool visitorBirthdateRequired;
  final bool visitorDocRequired;
  final List<CartItem> itemList;

  CartItemWrapper({
    required this.actionName,
    required this.venueName,
    required this.itemList,
    required this.fullNameRequired,
    required this.phoneRequired,
    required this.fanIdRequired,
    required this.visitorBirthdateRequired,
    required this.visitorDocRequired,
  });

  @override
  String toString() {
    return 'CartItemWrapper{actionName: $actionName, venueName: $venueName, '
        'fullNameRequired: $fullNameRequired, phoneRequired: $phoneRequired, '
        'fanIdRequired: $fanIdRequired visitorBirthdateRequired: $visitorBirthdateRequired, '
        'visitorDocRequired: $visitorDocRequired,}';
  }
}

class CartOrder{
  final double totalServiceCharge;
  final double totalSum;
  final int time;
  final String currency;
  final List<CartItemWrapper> bList;
  final List<VisitorData>? vdList;

  CartOrder({
    required this.totalServiceCharge,
    required this.totalSum,
    required this.time, required this.bList,
    required this.currency, this.vdList});

  @override
  String toString() {
    return 'CartOrder{totalServiceCharge: $totalServiceCharge, '
        'totalSum: $totalSum, time: $time, currency: $currency, bList: $bList, vdList:$vdList}';
  }

  int get numberOfTickets{
    int count = 0;
    for (var i in bList){
      count += i.itemList.length;
    }
    return count;
  }

  CartOrder copyWith({
    double? totalServiceCharge,
    double? totalSum,
    int? time,
    String? currency,
    List<CartItemWrapper>? bList,
    List<VisitorData>? vdList,
  }) {
    return CartOrder(
      totalServiceCharge: totalServiceCharge ?? this.totalServiceCharge,
      totalSum: totalSum ?? this.totalSum,
      time: time ?? this.time,
      currency: currency ?? this.currency,
      bList: bList ?? this.bList,
      vdList: vdList ?? this.vdList,
    );
  }
}