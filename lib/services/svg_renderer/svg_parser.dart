import 'dart:convert';
import 'package:flapp_widget/constants.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:jovial_svg/jovial_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart';

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${(255 * a).toInt().toRadixString(16).padLeft(2, '0')}'
      '${(255 * r).toInt().toRadixString(16).padLeft(2, '0')}'
      '${(255 * g).toInt().toRadixString(16).padLeft(2, '0')}'
      '${(255 * b).toInt().toRadixString(16).padLeft(2, '0')}';
}

class SVGInformation{
  final Size schemeSize;
  final ScalableImage scalableImage;
  final Map<int, Color> svgCategoriesIdColorMap;
  final List<int> userSeatIdList;

  const SVGInformation({
    required this.schemeSize,
    required this.scalableImage,
    required this.svgCategoriesIdColorMap,
    required this.userSeatIdList,
  });

  @override
  String toString() {
    return 'SVGInformation{schemeSize: $schemeSize, svgCategoriesIdColorMap: '
        '$svgCategoriesIdColorMap, userSeatIdList: $userSeatIdList}';
  }
}

class SVGDecorations{
  static Future<String> getSvgData(String url) async {
    if (accessCodeNotifier.value > 0){
      url = '$url&kdp=${accessCodeNotifier.value}';
    }
    int? userId = (await SharedPreferences.getInstance()).getInt('userId');
    if (userId is int){
      url = url.replaceFirst('userId=0', 'userId=${(await SharedPreferences.getInstance()).getInt('userId')}');
    }
    Uri schemeURI = Uri.parse(url);
    //print(schemeURI);
    final http.Response data = await http.get(schemeURI);
    return data.body;
  }

  static Future<SVGInformation> load(String placementUri) async{
    String data = await getSvgData(placementUri);
    List<dynamic> result = prepareSVG(data);
    Size svgSize = result.first ?? const Size(0, 0);
    String svgString = result[1];
    List<int> userSeatIdList = result[2];
    Map<int, Color> svgCategoriesMap = result.last;
    SVGInformation svgInformation = SVGInformation(schemeSize: svgSize,
        scalableImage: ScalableImage.fromSvgString(svgString),
        svgCategoriesIdColorMap: svgCategoriesMap, userSeatIdList: userSeatIdList);
    return svgInformation;// compact: true, bigFloats: true
  }

  static List<dynamic> prepareSVG(String svgData){
    final utf16Body = utf8.decode(svgData.codeUnits);
    XmlDocument document = XmlDocument.parse(utf16Body);
    Size? size;
    String? viewBox = document.findAllElements('svg').first.getAttribute('viewBox');

    if (viewBox != null) {
      List<String> viewBoxList = viewBox.split(' ');
      size = Size(double.parse(viewBoxList[2]), double.parse(viewBoxList[3]));
    }

    //ищем цвет и id активных категорий
    Map<int, Color> svgCategoriesMap = {};
    XmlElement sbtCategoriesElement = document.findAllElements('sbt:categories').first;
    List<XmlElement> sbtCategoryList = sbtCategoriesElement.findAllElements('sbt:category').toList();
    for (var cat in sbtCategoryList){
      svgCategoriesMap[int.parse(cat.getAttribute('sbt:id')!)] = HexColor.fromHex(cat.getAttribute('sbt:color')!);
    }

    //ищем выбранные места пользователя если есть
    List<int> userSeatIdList = [];
    for (var c in document.findAllElements('circle')){
      bool hasState = c.attributes.any((atr)=> atr.name.toString() == 'sbt:state' && atr.value.toString() == '2');
      bool hasOwner = c.attributes.any((atr)=> atr.name.toString() == 'sbt:owner' && atr.value.toString() == 'yes');
      if (hasState && hasOwner){
        String? potentialSeatId = c.getAttribute('sbt:id');
        if (potentialSeatId != null){
          //разобраться с типом состояния sbt:state
          userSeatIdList.add(int.parse(potentialSeatId));
        }
      }
    }
    String strFromDocument = (document
      ..descendants.firstWhere((test) => test.value == "Legend").parent?.remove()
      ..descendants.firstWhere((test) => test.value == "PriceCategory").parent?.remove()
      ..descendants.forEach((node){
        if (node.attributes.isNotEmpty){
          for (var atr in node.attributes) {
            if (atr.name.toString().contains('style')){
              List<String> atrs = atr.value.toString().split(';');
              for (var str in atrs){
                if (str.contains('opacity:')) {
                  atrs[atrs.indexOf(str)] = 'opacity:1';
                }
              }
              atr.value = atrs.join(';');}}}})
      ..findAllElements('circle').forEach((node) => node.remove())).toString();
    
    return [size, strFromDocument, userSeatIdList, svgCategoriesMap];
  }
}