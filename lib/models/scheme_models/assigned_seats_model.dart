import 'dart:math';
import "package:collection/collection.dart";
import 'package:convex_hull/convex_hull.dart';
import 'package:flapp_widget/models/scheme_models/seat_model.dart';
import 'package:flapp_widget/services/svg_renderer/svg_parser.dart';
import 'package:flapp_widget/ui/widgets/scheme_widgets/universal_painter.dart';
import 'package:flutter/material.dart';
//import 'package:material_color_utilities/hct/hct.dart';
//import 'package:material_color_utilities/palettes/tonal_palette.dart';

import '../../constants.dart';
import '../../ui/widgets/scheme_widgets/legend.dart';
import '../../ui/widgets/scheme_widgets/seat_widget.dart';
import 'category_price_model.dart';

Point<num> getSeatCoordinates(Seat seat) => seat.bil24seatObj.coordinates;

String getSeatSector(Seat seat) => seat.bil24seatObj.sector;
String getSeatOriginalNumber(Seat seat) => seat.bil24seatObj.number;
String getSeatOriginalRow(Seat seat) => seat.bil24seatObj.row;

int getSeatNumber(Seat seat) => int.parse(getSeatOriginalNumber(seat));
int getSeatRow(Seat seat) => int.parse(getSeatOriginalRow(seat));

num getSeatDX(Seat seat) => getSeatCoordinates(seat).x;
num getSeatDY(Seat seat) => getSeatCoordinates(seat).y;

//Класс для парсингинга данных схем
class AssignedSeatsProcessor{
  AssignedSeatsProcessor({required this.getSchema, required this.siData,
    required this.getSeatList, required this.actionEventId});
  final List<dynamic> getSchema;
  final dynamic getSeatList;
  final int actionEventId;
  final SVGInformation siData;
  List tariffPlanList = [];
  List<CategoryPriceObj> categoryPriceList = [];
  Map<int, bool> availabilityMap = {}; //Ключ - id места, значение - доступно/не доступно для продажи
  Map<String, Size> sectorNameMap = {};
  List<Widget> categoryInfoWidgetList = [];
  List<SectorScaffold> sectorList = [];
  Point ivSize = const Point(0.0, 0.0);
  Point coef = const Point(0.0, 0.0);
  double schemeCoef = 0.0;
  int capacity = 0;
  String get currency{
    return getSeatList['currency'];
  }

  //Поиск максимального радиуса для места текущей схемы
  double findMaxRadius(List<BIL24SeatObj> circles) {
    double left = 0.0; // Начальная левая граница для бинарного поиска.
    double right = 10; // Начальная правая граница для бинарного поиска.
    while (right - left > 1e-6) { // Точность бинарного поиска
      double mid = (left + right) / 2.0; // Текущее значение радиуса.
      if (isValidConfiguration(circles, mid)) {
        // Если текущий радиус подходит, уменьшаем правую границу.
        left = mid;
      } else {
        // Если текущий радиус не подходит, увеличиваем левую границу.
        right = mid;
      }
    }
    // Возвращаем максимально возможный радиус.
    if (seatMode == 'theatre'){
      return left * 0.9;
    }
    return left * 0.7;
  }

  bool isValidConfiguration(List<BIL24SeatObj> circles, double radius) {
    for (int i = 0; i < circles.length; i++) {
      for (int j = i + 1; j < circles.length; j++) {
        double distance = sqrt(
            pow(circles[i].x - circles[j].x, 2) + pow(circles[i].y - circles[j].y, 2));

        if (distance < 2 * radius) {
          // Если расстояние меньше удвоенного текущего радиуса, окружности пересекаются.
          return false;
        }
      }
    }
    return true;
  }

  //Настройка размера схемы и положения мест
  Point calculateCoefficient(List seatData){
    List<Point> coordinatesList = [];
    double deviceCoef = 1.0;
    double corner = 0.0;
    num width = 0;
    num height = 0;
    num maxX = 0;
    num maxY = 0;
    double minX = double.infinity;
    double minY = double.infinity;

    for (var element in seatData){
      coordinatesList.add(Point(double.parse(element['x']), double.parse(element['y'])));
    }

    for (final point in coordinatesList) {
      if (point.x < minX) {
        minX = point.x.toDouble();
      }
      if (point.y < minY) {
        minY = point.y.toDouble();
      }
    }

    double offsetX = -minX;
    double offsetY = -minY;

    //Приводим координаты максимально к верхнему левому углу
    for(var point in coordinatesList){
      if (point.x + offsetX > maxX || point.y + offsetY > maxY){
        maxX = point.x;
        maxY = point.y;
      }
    }

    corner = (max(maxX.toDouble(), maxY.toDouble()));

    if (screenWidth < 900){
      width = screenWidth;
      height = screenHeight*0.8;

      deviceCoef = 0.7;
    } else {
      width = 800;  //coordinatesList.map((point) => point.x).reduce(max) ; Параметры размера схемы для моб и для десктопа
      height = 800;  //coordinatesList.map((point) => point.y * screenHeight).reduce(max);
      deviceCoef = 0.7;
    }

    //Размер схемы для устройства в зависимости от ширины его экрана
    ivSize = Point(width, height);

    //schemeSize = Size(coordinatesList.map((point) =>
    // point.x*(height*deviceCoef/corner)).reduce(max),
    // coordinatesList.map((point) => point.y*(height*deviceCoef/corner)).reduce(max));

    coef = Point(width*deviceCoef/corner, width*deviceCoef/corner);
    return Point(width*deviceCoef/corner, width*deviceCoef/corner);
  }

  Offset calculateCentroid(final Iterable<Seat> hull, double factor) {
    var xSum = hull.map((seat) => seat.bil24seatObj.coordinates.x.toDouble()).reduce((a, b) =>( a + b));
    var ySum = hull.map((seat) => seat.bil24seatObj.coordinates.y.toDouble()).reduce((a, b) =>( a + b));

     return Offset(((xSum/hull.length)*factor), ((ySum/hull.length)*factor));
  }

  //Генерация цветов для категорий
  List<List<int>> generateUniqueColors(int count) {
    Set<List<int>> colors = {}; // Используем Set для гарантированной уникальности
    Random random = Random();

    while (colors.length < count) {
      int red = random.nextInt(256);
      int green = random.nextInt(256);
      int blue = random.nextInt(256);

      int shiftRed = random.nextInt(101) - 50; // Случайный сдвиг для красного от -50 до 50
      int shiftGreen = random.nextInt(101) - 50; // Случайный сдвиг для зеленого от -50 до 50
      int shiftBlue = random.nextInt(101) - 50;

      red = (red + shiftRed).clamp(0, 255);
      green = (green + shiftGreen).clamp(0, 255);
      blue = (blue + shiftBlue).clamp(0, 255);

      // Проверяем светлость цвета
      int lightness = red + green + blue;
      if (lightness < 500 && Color.fromRGBO(red,green,blue, 1.0) != Colors.white) {
        colors.add([red, green, blue]);
      }
    }

    return colors.toList(); // Преобразуем Set обратно в List
  }

  //Ключ - id категории, значение - ее цвет в типе Color
  Map<dynamic, Color> generateCategoryColorMap(){
    Map<dynamic, Color> colorMap = {};
    int countOfCategories = 0;
    countOfCategories = getSeatList['categoryList'].length;
    List<List<int>> uniqueColors = generateUniqueColors(countOfCategories);

    for (var element in getSeatList['categoryList']){ // getSeatList[seatList] это 4 массив в ответе get_seat_list
      if (element['placement']){
        List<int> tempElement = uniqueColors.last;
        uniqueColors.removeLast();
        colorMap[element['categoryPriceId']] = Color.fromRGBO(tempElement[0], tempElement[1], tempElement[2], 1.0);
      }
    }

    return colorMap;
  }

  //Ключ - id места, значение - объект CategoryPrice
  Map<int, CategoryPriceObj> createSeatIdCategoryMap(){
    categoryPriceList.clear();
    Map<int, CategoryPriceObj> seatMap = {};
    //Map<dynamic, Color> randomColorForCategoriesMap = generateCategoryColorMap();
    Map<int, Color> svgCategoriesMap = siData.svgCategoriesIdColorMap;

    tariffPlanList = getSeatList['tariffPlanList'];

    //Список объектов типа CategoryPriceObj
    for (var element in getSeatList['categoryList']){
      Map<int, double> tm = (element['tariffIdMap'] as Map<String, dynamic>)
          .map((k, e) => MapEntry(int.parse(k), (e as num).toDouble()));
      if (element['placement']){
        categoryPriceList.add(CategoryPriceObj(id: element['categoryPriceId'],
            name: element['categoryPriceName'], tariffIdMap: tm,
            color: svgCategoriesMap[element['categoryPriceId']]!,
            price: element['price'], availability: element['availability'],
            placement: element['placement']));
      }
    }

    //заполняем мэп доступности мест
    for (var element in getSeatList['seatList']){
      if (element['placement']){
        seatMap[element['seatId']] = categoryPriceList.firstWhere
          ((el) => el.id == element['categoryPriceId']);
        if (siData.userSeatIdList.contains(element['seatId'])){
          //print(element);
          availabilityMap[element['seatId']] = true;
        } else {
          availabilityMap[element['seatId']] = element['available'];
        }
      }
    }

    categoryInfoWidgetList.clear();
    categoryInfoWidgetList.add(const UserSelectionLegend());
    for (var element in categoryPriceList){
      if(element.availability > 0 && element.placement){
        categoryInfoWidgetList.add(CategoryInfoWidget(categoryPrice: element, currency: currency,));
      }
    }

    return seatMap;
  }

  //Создание списка виджетов мест
  List<Seat> createSeatList(){
    List<BIL24SeatObj> seatObjList = [];
    List<Seat> seatWidgetList = [];
    Point coefficient = calculateCoefficient(getSchema); // коэффициент расстояний между местами
    Map<int, CategoryPriceObj> cMap = createSeatIdCategoryMap();
    //double deviceCoef = 0.7;
    schemeCoef = coefficient.x.toDouble();

    for (var element in getSchema){
      seatObjList.add(BIL24SeatObj(
          sector: element['sector'], row: element['row'], number: element['number'],
          coordinates: Point(double.parse(element['x'])*schemeCoef,
              double.parse(element['y'])*schemeCoef),
          seatId: element['seatId'], categoryId: cMap[element['seatId']]!.id));
    }

    var sectorMap = groupBy(seatObjList, (obj) => obj.sector);
    List<BIL24SeatObj> randomSlice = sectorMap.values.firstWhere((value)=>value.length >= 10);
    double maxRadius = findMaxRadius(randomSlice.sublist(0,10));

    for (var seatModel in seatObjList){
      seatWidgetList.add(Seat(bil24seatObj: seatModel, //key: UniqueKey()
        category: cMap[seatModel.seatId]!,
        radius: double.parse((maxRadius).toStringAsFixed(2)),
        available: availabilityMap[seatModel.seatId]!)
      );
    }

    capacity = seatWidgetList.length;
    return seatWidgetList;
  }

  List<SectorScaffold> getSectorScaffoldList(){
    List<Seat> seatWidgetList = [];
    Map<String, List<Seat>> sectorMap = {};

    seatWidgetList = createSeatList();

    for (var seat in seatWidgetList){
      if (!sectorMap.containsKey(getSeatSector(seat))){
        sectorMap[getSeatSector(seat)] = [seat];
      } else {
        sectorMap[getSeatSector(seat)]?.add(seat);
      }
    }

    final sorted = Map.fromEntries(sectorMap.entries.toList()
      ..sort((b, a) => a.value.length.compareTo(b.value.length)));

    List<SectorScaffold> list = [];
    for (var entry in sorted.entries){
      var seatLayoutHull = convexHull<Seat>(
          entry.value,
          x: (seat) => (getSeatDX(seat).toInt().toDouble()),
          y: (seat) => (getSeatDY(seat).toInt().toDouble())
      );

      Iterable<Offset> sectorHull = seatLayoutHull.map((seat){
        return Offset((getSeatDX(seat).toInt().toDouble()),
            (getSeatDY(seat).toInt().toDouble()));});

      double minx = seatLayoutHull.map((seat) => seat.bil24seatObj
          .coordinates.x.toDouble()).reduce(min);
      double maxx = seatLayoutHull.map((seat) => seat.bil24seatObj
          .coordinates.x.toDouble()).reduce(max);
      double miny = seatLayoutHull.map((seat) => seat.bil24seatObj
          .coordinates.y.toDouble()).reduce(min);
      double maxy = seatLayoutHull.map((seat) => seat.bil24seatObj
          .coordinates.y.toDouble()).reduce(max);

      double width = maxx - minx;
      double height = maxy - miny;

      Offset center = calculateCentroid(seatLayoutHull, 1);

      list.add(SectorScaffold(capacity: entry.value.length, //todo пересчитать
          sectorName: entry.key, size: Size(width, height), centerOffset: center,
          convexHullPoints: sectorHull.toList(), seatList: entry.value));
    }
    sectorList = list;
    return list;
  }
}
