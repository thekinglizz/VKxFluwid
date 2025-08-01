import 'package:flutter/material.dart';

import '../constants.dart';
import '../i18n/app_localizations.dart';
import '../ui/screens/acton_mode_screen.dart';
import '../ui/screens/after_payment_screen.dart';
import '../ui/screens/error_screen.dart';

setGlobalUriParams(Uri url) {
  url = url;

  //Обязательные параметры
  //fid = url.queryParameters['frontendId'];
  //token = url.queryParameters['token'];
  actionId = url.queryParameters['id'];
  actionEventId = url.queryParameters['actionEventId'];
  cityId = url.queryParameters['cityId'];

  agreement = url.queryParameters['agr'];
  failUrl =
      url.queryParameters['fail'] ?? '${Uri.base.origin}${Uri.base.path}?fail';
  successUrl = url.queryParameters['success'] ??
      '${Uri.base.origin}${Uri.base.path}?success'; //? в конце
  if (url.queryParameters['zone'] == 'test') {
    port = 'https://api.bil24.pro:1240/json';
    zone = 'test';
  }
  if (url.queryParameters['zone'] == 'real') {
    port = 'https://api.bil24.pro/json';
    zone = 'real';
  }

  //Необязательные параметры
  hint = url.queryParameters['hint'];
  date = url.queryParameters['date'];
  available = url.queryParameters['available'];
  promo = url.queryParameters['promo'];
  decorations = url.queryParameters['decorations']; //decorations=off
  seatMode = url.queryParameters['seatMode']; //seatMode=theatre
  hull = url.queryParameters['hull']; //hull=off

  if (url.queryParameters['schemeStyle'] == 'fill' ||
      url.queryParameters['schemeStyle'] == 'stroke') {
    schemeStyle = url.queryParameters['schemeStyle'];
  } else {
    schemeStyle = 'fill';
  }
  if (url.queryParameters['sectorName'] == 'off') {
    sectorName = 'off';
  }

  // Параметры от VK
  extraVkPlatform = url.queryParameters["extra_vkplatform"];
  interactionId = url.queryParameters["interaction_id"];
  extraSessionId = url.queryParameters["extra_session_id"];
  extraUnixTimeClick = url.queryParameters["extra_unixtime_click"];
  extraPlatform = url.queryParameters["extra_platform"];
  utmSource = url.queryParameters["utm_source"];
  utmCampaign = url.queryParameters["utm_campaign"];
  utmMedium = url.queryParameters["utm_medium"];
  utmTerm = url.queryParameters["utm_term"];
  utmContent = url.queryParameters["utm_content"];

  //print("$fid, $token, $actionId, $cityId, $failUrl, $successUrl, $port, $zone, "
  //"$calendar, $hint, $agreement, $date, $available, $promo, $stageRender, $schemeStyle");
}

class RouteGenerator {
  static List<Route<dynamic>> generateHomePage(String route) {
    if (route.startsWith("/?success")) {
      magicSuccessUrl = route.substring(route.lastIndexOf('?') + 1);
      return [
        MaterialPageRoute(builder: (context) {
          return const SuccessScreen();
        })
      ];
    }
    if (route == "/?fail") {
      return [
        MaterialPageRoute(builder: (context) {
          return const FailScreen();
        })
      ];
    }
    if (Uri.parse(route).queryParameters.isNotEmpty) {
      return [
        MaterialPageRoute(
          builder: (context) {
            return const FluwidHome();
          },
        )
      ];
    } else {
      return [
        MaterialPageRoute(builder: (context) {
          return ErrorScreen(
            error: AppLocalizations.of(context)!.uriConfigurationError,
          );
        })
      ];
    }
  }
}
