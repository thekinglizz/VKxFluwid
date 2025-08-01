import 'dart:async';
import 'dart:convert';
import 'package:flapp_widget/constants.dart';
import 'package:flapp_widget/services/svg_renderer/svg_parser.dart';
import 'package:flapp_widget/view_models/user_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../models/action.dart';
import '../models/cart_models/cart.dart';
import '../models/cart_models/visitor_data.dart';
import '../models/composited_category.dart';
import '../models/scheme_models/assigned_seats_model.dart';
import '../models/user.dart';

class PlatformAPI {
  static Future<http.Response> platformResponse(
      Map<String, dynamic> body) async {
    return http.post(
      Uri.parse(port),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );
  }
}

class ActionAPI extends PlatformAPI {
  static Future<dynamic> chkConnection() async {
    try {
      final chkResponse = await PlatformAPI.platformResponse(<String, dynamic>{
        'fid': fid,
        'token': token,
        'command': 'GET_ACTION_EXT',
        'cityId': cityId,
        'actionId': actionId,
      }).timeout(const Duration(seconds: 3));
      if (chkResponse.statusCode == 200) {
        print("GET_ACTION_EXT");
        String data = chkResponse.body;
        var jsonResponse = jsonDecode(data);
        if (jsonResponse['resultCode'] != 0) {
          actionError = jsonResponse['description'];
        }
        Action action =
            Action.fromJson((jsonResponse as Map<String, dynamic>)["action"]);
        if (action.venueList.isEmpty) return "empty";
        for (var venue in action.venueList) {
          //удаляем пустые сеансы
          if (venue.actionEventList
              .any((element) => element.categoryLimitList.isNotEmpty)) {
            venue.actionEventList.removeWhere((element) =>
                element.categoryLimitList.isEmpty &&
                element.placementUrl == null);
          }
        }
        return action;
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      if (port.contains('bil24')) {
        switch (zone) {
          case 'test':
            port = 'https://api2.bil24.pro:1240/json';
          case 'real':
            port = 'https://api2.bil24.pro/json';
        }
      }
      return false;
    }
  }

  static Future<dynamic> fetchAction() async {
    final chk = await chkConnection();
    if (chk is Action) {
      return chk;
    }
    if (chk is bool) {
      final response = await PlatformAPI.platformResponse(<String, dynamic>{
        'fid': fid,
        'token': token,
        'command': 'GET_ACTION_EXT',
        'cityId': cityId,
        'actionId': actionId,
      });
      if (response.statusCode == 200) {
        print("GET_ACTION_EXT RETRY");
        String data = response.body;
        var jsonResponse = jsonDecode(data);
        if (jsonResponse['resultCode'] != 0) {
          actionError = jsonResponse['description'];
        }
        Action action = Action.fromJson(
            (jsonDecode(response.body) as Map<String, dynamic>)["action"]);
        if (action.venueList.isEmpty) return "empty";
        for (var venue in action.venueList) {
          //удаляем пустые сеансы
          if (venue.actionEventList
              .any((element) => element.categoryLimitList.isNotEmpty)) {
            venue.actionEventList.removeWhere((element) =>
                element.categoryLimitList.isEmpty &&
                element.placementUrl == null);
          }
        }
        return action;
      } else {
        throw Exception('Failed to get GET_ACTION_EXT response.');
      }
    }
  }

  static Future fetchScheme(int actionEventId) async {
    final response = await PlatformAPI.platformResponse(<String, dynamic>{
      'fid': fid,
      'token': token,
      'command': 'GET_SCHEMA',
      'actionEventId': actionEventId
    });
    if (response.statusCode == 200) {
      String data = response.body;
      var jsonResponse = jsonDecode(data);
      print(jsonResponse['command']);
      return jsonResponse['seatList'];
    } else {
      throw Exception('Failed to get response.');
    }
  }

  static Future fetchSeatList(int actionEventId) async {
    final response = await PlatformAPI.platformResponse(<String, dynamic>{
      'fid': fid,
      'token': token,
      'command': 'GET_SEAT_LIST',
      'actionEventId': actionEventId,
      'availableOnly': false
    });
    if (response.statusCode == 200) {
      String data = response.body;
      var jsonResponse = jsonDecode(data);
      print(jsonResponse['command']);
      return jsonResponse;
    } else {
      throw Exception('Failed to get response.');
    }
  }

  static Future<AssignedSeatsProcessor> computeSchemeData(
      int actionEventId, String placementUri) async {
    final schemeData = await fetchScheme(actionEventId);
    final seatListData = await fetchSeatList(actionEventId);
    final si = await SVGDecorations.load(placementUri);
    AssignedSeatsProcessor parsedData = AssignedSeatsProcessor(
        getSchema: schemeData,
        getSeatList: seatListData,
        actionEventId: actionEventId,
        siData: si);
    return parsedData;
  }

  static Future<dynamic> checkKDP(int tempAccessCode) async {
    final successAuth = await PlatformAPI.platformResponse(
        <String, dynamic>{'fid': fid, 'token': token, 'command': 'AUTH'});
    if (successAuth.statusCode == 200) {
      final verification = await PlatformAPI.platformResponse(<String, dynamic>{
        'fid': fid,
        'token': token,
        'command': 'CHECK_KDP',
        'kdp': tempAccessCode,
        'actionId': actionId,
        'userId': jsonDecode(successAuth.body)['userId'],
        'sessionId': jsonDecode(successAuth.body)['sessionId'],
      });
      if (verification.statusCode == 200) {
        final result = jsonDecode(verification.body);
        if (result['resultCode'] == 0) {
          accessCodeNotifier.value = tempAccessCode;
        } else {
          return false;
        }
      } else {
        throw Exception('Failed to get KDP_CHECK response.');
      }
    } else {
      throw Exception('Failed to get AUTH response.');
    }
  }
}

class UserAPI extends PlatformAPI {
  static User synthUser = const User(
      userId: 0,
      sessionId: '',
      email: '',
      state: UserStates.unknown,
      totalSeatsInReserve: 0);

  static Future<int> auth(WidgetRef ref, String email) async {
    final response = await PlatformAPI.platformResponse(
        <String, dynamic>{'fid': fid, 'token': token, 'command': 'AUTH'});
    if (response.statusCode == 200) {
      String data = response.body;
      var jsonResponse = jsonDecode(data);
      synthUser = User(
          userId: jsonResponse['userId'],
          sessionId: jsonResponse['sessionId'],
          email: email,
          state: UserStates.processing,
          totalSeatsInReserve: 0);
      ref.read(asyncUserProvider.notifier).saveSynthUser(synthUser);
      return jsonResponse['resultCode'];
    } else {
      throw Exception('Failed to get AUTH response.');
    }
  }

  static bindEmail(WidgetRef ref, String email) async {
    int successAuth = await auth(ref, email);
    if (successAuth == 0) {
      final response = await PlatformAPI.platformResponse(<String, dynamic>{
        'fid': fid,
        'token': token,
        'command': 'BIND_EMAIL',
        'userId': synthUser.userId,
        'sessionId': synthUser.sessionId,
        'email': email,
      });
      if (response.statusCode == 200) {
        String data = response.body;
        var jsonResponse = jsonDecode(data);
        print(jsonResponse['command'] +
            ' ' +
            jsonResponse['resultCode'].toString());
      } else {
        throw Exception('Failed to get BIND_EMAIL response.');
      }
    }
  }

  static Future<dynamic> confirmEmail(String code, User tempUser) async {
    final response = await PlatformAPI.platformResponse(<String, dynamic>{
      'fid': fid,
      'token': token,
      'command': 'CONFIRM_EMAIL',
      'userId': tempUser.userId,
      'sessionId': tempUser.sessionId,
      'code': code,
    });
    if (response.statusCode == 200) {
      String data = response.body;
      var jsonResponse = jsonDecode(data);
      print(jsonResponse['command'] +
          ' ' +
          jsonResponse['resultCode'].toString());
      if (jsonResponse['resultCode'] == 0) {
        return User(
            userId: jsonResponse['userId'],
            sessionId: jsonResponse['sessionId'],
            email: jsonResponse['email'],
            state: UserStates.authorized,
            totalSeatsInReserve: 0);
      } else {
        return jsonResponse['resultCode'];
      }
    } else {
      throw Exception('Failed to get CONFIRM_EMAIL response.');
    }
  }

  static Future<dynamic> getUserInfo(User user) async {
    final response = await PlatformAPI.platformResponse(<String, dynamic>{
      'fid': fid,
      'token': token,
      'command': 'GET_USER_INFO',
      'userId': user.userId,
      'sessionId': user.sessionId,
    });
    if (response.statusCode == 200) {
      String data = response.body;
      var jsonResponse = jsonDecode(data);
      print(jsonResponse['command'] +
          ' ' +
          jsonResponse['resultCode'].toString());
      if (jsonResponse['resultCode'] == 0) {
        return jsonResponse['reservedSeats'];
      } else {
        return jsonResponse['command'] +
            ' ' +
            jsonResponse['resultCode'].toString();
      }
    } else {
      throw Exception('Failed to get CONFIRM_EMAIL response.');
    }
  }

  static Future<String> getUserEmail(User user) async {
    final response = await PlatformAPI.platformResponse(<String, dynamic>{
      'fid': fid,
      'token': token,
      'command': 'GET_EMAIL',
      'userId': user.userId,
      'sessionId': user.sessionId,
    });
    if (response.statusCode == 200) {
      String data = response.body;
      var jsonResponse = jsonDecode(data);
      print(jsonResponse['command'] +
          ' ' +
          jsonResponse['resultCode'].toString());
      if (jsonResponse['resultCode'] == 0) {
        return jsonResponse['email'];
      } else {
        return '';
      }
    } else {
      throw Exception('Failed to get GET_EMAIL response.');
    }
  }
}

class CartAPI extends PlatformAPI {
  static Future<CartOrder> getCart(User user) async {
    List<CartItem> tempList = [];
    List<CartItemWrapper> resultList = [];
    late CartOrder cartOrder;
    late String currency;
    final response = await PlatformAPI.platformResponse(<String, dynamic>{
      'fid': fid,
      'token': token,
      'command': 'GET_CART',
      'rawCoordinates': true,
      'userId': user.userId,
      'sessionId': user.sessionId,
    });
    if (response.statusCode == 200) {
      String data = response.body;
      var jsonResponse = jsonDecode(data);
      //print(jsonResponse);
      if ((jsonResponse['actionEventList'] as List<dynamic>).isNotEmpty) {
        currency = jsonResponse['currency'];
        for (var item in jsonResponse['actionEventList']) {
          for (var itemExt in item['seatList']) {
            tempList.add(CartItem(
                categoryPriceName: itemExt['categoryPriceName'],
                day: item['day'],
                time: item['time'],
                price: itemExt['price'],
                seatId: itemExt['seatId'],
                currency: jsonResponse['currency'],
                tariffName: itemExt['tariffPlanName'],
                tariffPlanId: itemExt['tariffPlanId'],
                sector: itemExt['sector'],
                row: itemExt['row'],
                number: itemExt['number'],
                serviceCharge: itemExt['serviceCharge'],
                discountReason: itemExt["discountReason"],
                categoryPriceId: itemExt["categoryPriceId"]));
          }
          resultList.add(
            CartItemWrapper(
                actionName: item['actionName'],
                venueName: item['venueName'],
                itemList: tempList,
                fullNameRequired: item['fullNameRequired'],
                phoneRequired: item['phoneRequired'],
                fanIdRequired: item['fanIdRequired'],
                visitorBirthdateRequired: item['visitorBirthdateRequired'],
                visitorDocRequired: item['visitorDocRequired']),
          );
          tempList = [];
        }
      } else {
        currency = '';
      }
      cartOrder = CartOrder(
        totalSum: jsonResponse['totalSum'],
        currency: currency,
        totalServiceCharge: jsonResponse['totalServiceCharge'],
        time: jsonResponse['time'],
        bList: resultList,
      );
      return cartOrder;
    } else {
      throw Exception('Failed to get GET_CART response.');
    }
  }

  static Future<dynamic> createOrder(User user, List<dynamic> reqFields) async {
    Map<String, dynamic> requestBody = {
      'fid': fid,
      'token': token,
      'command': 'CREATE_ORDER',
      'userId': user.userId,
      'sessionId': user.sessionId,
      'successUrl': successUrl + '?' + zone,
      'failUrl': failUrl
    };
    if (reqFields.isNotEmpty) {
      reqFields[0] != '' ? requestBody['fullName'] = reqFields[0] : null;
      reqFields[1] != '' ? requestBody['phone'] = reqFields[1] : null;
      if (reqFields[2] is List) {
        List list = [];
        for (var vd in reqFields[2]!) {
          list.add((vd as VisitorData).toJson()
            ..removeWhere((key, value) => value == '' || value == null));
        }
        requestBody['visitorDataList'] = list;
      }
    }
    final response = await PlatformAPI.platformResponse(requestBody);
    if (response.statusCode == 200) {
      String data = response.body;
      var jsonResponse = jsonDecode(data);
      if (jsonResponse['resultCode'] == 0) {
        if (jsonResponse['statusExtStr'] == 'NEW') {
          //print(jsonResponse['formUrl']);
          return Uri.parse(jsonResponse['formUrl']);
        }
        if (jsonResponse['statusExtStr'] == 'PAID') {
          return Uri.parse(successUrl + '?' + zone);
        }
      }
      return jsonResponse['description'];
    } else {
      throw Exception('Failed to get CREATE_ORDER response.');
    }
  }

  static reservationHelper(User user, List categoryList) async {
    Map<String, dynamic> kdpParam = {};
    if (accessCodeNotifier.value > 0) {
      kdpParam['kdp'] = accessCodeNotifier.value;
    }

    final response = await PlatformAPI.platformResponse(<String, dynamic>{
      'fid': fid,
      'token': token,
      'command': 'RESERVATION',
      'type': 'RESERVE',
      'userId': user.userId,
      'sessionId': user.sessionId,
      'categoryList': categoryList,
    }..addAll(kdpParam));

    if (response.statusCode == 200) {
      String data = response.body;
      var jsonResponse = jsonDecode(data);
      print(jsonResponse['command'] + ' ' + jsonResponse['description']);
      if (jsonResponse['resultCode'] == 101 ||
          jsonResponse['resultCode'] == -1) {
        return jsonResponse['description'];
      } else {}
    } else {
      throw Exception('Failed to get response.');
    }
  }

  static Future<dynamic> reserveGeneralAdmission(
      Map<int, List<CompositedCategory>> data, User user) async {
    late dynamic command;
    for (var event in data.entries) {
      List<dynamic> reserveList = [];
      for (var category in event.value) {
        if (category is CompositedTariffCategory) {
          for (var tariff in category.tariffsSelection.entries) {
            if (tariff.value > 0) {
              reserveList.add(<String, dynamic>{
                'categoryPriceId': category.categoryPriceId,
                'quantity': tariff.value,
                'tariffPlanId': tariff.key.id,
                'expectedPrice': tariff.key.price
              });
            }
          }
        } else {
          if (category.selected > 0) {
            reserveList.add(<String, dynamic>{
              'categoryPriceId': category.categoryPriceId,
              'quantity': category.selected,
            });
          }
        }
      }
      if (reserveList.isNotEmpty) {
        command = await reservationHelper(user, reserveList);
        if (command is String) {
          return command;
        }
      }
    }
  }

  static Future<dynamic> reserveSeats(String command, User user, int seatId,
      int? tariffPlanId, double? expectedPrice, String? fanId) async {
    Map<String, dynamic> kdpParam = {};
    if (accessCodeNotifier.value > 0) {
      kdpParam['kdp'] = accessCodeNotifier.value;
    }

    Map<String, dynamic> seat = {};
    seat = {'seatId': seatId};
    // если к месту применен тарифный план
    if (tariffPlanId is int) {
      seat['tariffPlanId'] = tariffPlanId;
    }
    if (expectedPrice is double) {
      seat['expectedPrice'] = expectedPrice;
    }

    //если к месту применен fanId
    if (fanId is String) {
      seat['fanId'] = fanId;
    }

    final response =
        await PlatformAPI.platformResponse(command == 'UN_RESERVE_ALL'
            ? (<String, dynamic>{
                'fid': fid,
                'token': token,
                'command': 'RESERVATION',
                'type': command,
                'userId': user.userId,
                'sessionId': user.sessionId,
              }..addAll(kdpParam))
            : <String, dynamic>{
                'fid': fid,
                'token': token,
                'command': 'RESERVATION',
                'type': command,
                'seatList': [seat],
                'userId': user.userId,
                'sessionId': user.sessionId,
              }
          ..addAll(kdpParam));

    if (response.statusCode == 200) {
      String data = response.body;
      var jsonResponse = jsonDecode(data);
      if (jsonResponse['resultCode'] == 0) {
        return jsonResponse['cartTimeout'];
      } else {
        return jsonResponse['description'];
      }
    } else {
      throw Exception('Failed to get RESERVATION response.');
    }
  }

  static Future<dynamic> addPromoCodes(
      User user, List<String> promoCodes) async {
    Map<String, dynamic> requestBody = {
      'fid': fid,
      'token': token,
      'command': 'ADD_PROMO_CODES',
      'promoCodeList': promoCodes,
      'userId': user.userId,
      'sessionId': user.sessionId,
    };
    final response = await PlatformAPI.platformResponse(requestBody);
    if (response.statusCode == 200) {
      String data = response.body;
      var jsonResponse = jsonDecode(data);
      List? newPromoCodeList = jsonResponse['newPromoCodeList'];
      List? errorPromoCodeList = jsonResponse['errorPromoCodeList'];
      List? existPromoCodeList = jsonResponse['existPromoCodeList'];
      if (errorPromoCodeList != null && errorPromoCodeList.isNotEmpty) {
        if (errorPromoCodeList.length > 1) {
          return [-11, errorPromoCodeList];
        } else {
          return [-1, errorPromoCodeList];
        }
      }
      if (newPromoCodeList != null && newPromoCodeList.isNotEmpty) {
        if (newPromoCodeList.length > 1) {
          return [11, newPromoCodeList];
        } else {
          return [1, newPromoCodeList];
        }
      }
      if (existPromoCodeList != null && existPromoCodeList.isNotEmpty) {
        if (existPromoCodeList.length > 1) {
          return [22, existPromoCodeList];
        } else {
          return [2, existPromoCodeList];
        }
      }

      if (jsonResponse["resultCode"] == -1) {
        return [jsonResponse["description"]];
      }
      if (jsonResponse["resultCode"] == 101) {
        return [jsonResponse["description"]];
      }
      return [jsonResponse];
    } else {
      throw Exception('Failed to ADD_PROMO_CODES');
    }
  }
}
