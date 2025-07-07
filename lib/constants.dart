import 'dart:ui';

import 'package:flapp_widget/styles/ui_styles.dart';
import 'package:flapp_widget/view_models/user_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'i18n/app_localizations.dart';
import 'theme.dart';

String version = 'v3.7.8';

enum SchemeType {generalAdmission, assignedSeats, mixed, undefined}

late FragmentProgram fragmentProgram;
int actionEventIndex = 0;

dynamic actionId;
dynamic actionEventId;
dynamic cityId;
dynamic agreement;
dynamic fid;
dynamic token;
dynamic successUrl;
dynamic magicSuccessUrl;
dynamic failUrl;
dynamic port;
dynamic zone;
dynamic date;
dynamic hint;
dynamic available;
dynamic language;
dynamic promo;
dynamic memo;
dynamic schemeStyle;
dynamic decorations;
dynamic seatMode;
dynamic sectorName;
dynamic hull;

// Нотифаеры для элементов главного экрана
final ValueNotifier<ScrollPhysics> physics = ValueNotifier<ScrollPhysics>
  (const AlwaysScrollableScrollPhysics()); // Для отключения скролла всего экрана при работе со схемами
final ValueNotifier<int> tabIndex = ValueNotifier<int> (0);
final ValueNotifier<int> accessCodeNotifier = ValueNotifier<int> (0);

//Переменная которую слушает из мейн скрина сектор виджет для подсказки общей суммы мест
final ValueNotifier<double> totalSum = ValueNotifier(0);

final double physicalHeight = WidgetsBinding
    .instance.platformDispatcher.views.first.physicalSize.height;
final double devicePixelRatio = WidgetsBinding
    .instance.platformDispatcher.views.first.devicePixelRatio;
final double screenHeight = physicalHeight / devicePixelRatio;

final double physicalWidth = WidgetsBinding
    .instance.platformDispatcher.views.first.physicalSize.width;
final double screenWidth = physicalWidth / devicePixelRatio;

const baseColor = Color(0xff104C81);
const mediumColor = Color(0xff4C77B1);
const darkColor = Color(0xFF072743);
const greyColor = Color(0xff717171);

var inputFormat = DateFormat('dd.MM.yyyy HH:mm');
var titleFormat = DateFormat(' d MMMM y EEEE', 'ru');
var sessionFormat = DateFormat(' d MMMM EE ', 'en');

String p = "[a-zA-Z0-9+._%-+]{1,256}@[a-zA-Z0-9][a-zA-Z0-9-]{0,64}"
    "(.[a-zA-Z0-9][a-zA-Z0-9-]{0,25})+";
RegExp emailRegExp = RegExp(p);
List<String> supportedLng = ['ru', 'en'];
String actionError = '';

extension CapExtension on String{
  String toCapitalized() => length > 0 ? '${this[0].toUpperCase()}${substring(1)}':'';
  String toTitleCase()=> replaceAll(RegExp(' +'), ' ').split(' ')
      .map((str) => str.toCapitalized()).join(' ');
}

Color darken(Color color, [double amount = .04]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

Color lighten(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

  return hslLight.toColor();
}

Future<void> launchLink(Uri url) async {
  await canLaunchUrl(url) ?
  await launchUrl(url) :
  throw 'Could not launch$url';
}

//Глобальные виджеты
class UserDialog extends StatelessWidget {
  const UserDialog({super.key, required this.userMessage, required this.redirectFlag});
  final String userMessage;
  final bool redirectFlag;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0))),
        content: Text(userMessage,
          style: customTextStyle(null, screenWidth > 900 ? 20 : 18, 'Regular'),),
        actions: <Widget>[
          !redirectFlag ? TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child:  Text('OK', style: customTextStyle(null, screenWidth > 900 ? 20 : 18, 'Regular'),)
          ) : TextButton(
            onPressed: () {Navigator.popUntil(context, (route) => route.isFirst);}, //todo check
            child: Text(AppLocalizations.of(context)!.authRedirectLabel,
              style: customTextStyle(MaterialTheme.lightScheme().primary,
                  screenWidth > 900 ? 20 : 18, 'Regular'),),
          )
        ],
      );
  }
}

class EmptyCartContent extends StatelessWidget {
  const EmptyCartContent({super.key, required this.userMsg});
  final String userMsg;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220.0,
      width: 220.0,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(CupertinoIcons.shopping_cart, size: 80, color: MaterialTheme.lightScheme().onSurfaceVariant),
            const SizedBox(height: 20.0,),
            Text(userMsg, style: customTextStyle(MaterialTheme.lightScheme().onSurfaceVariant,
                    screenWidth > 900 ? 20 : 18, 'Regular')),
          ],
        ),
      ),
    );
  }
}

class CartWidgetIcon extends ConsumerWidget {
  const CartWidgetIcon({super.key, required this.iconData, required this.size, required this.color});
  final IconData iconData;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context, ref) {
    final uvm = ref.watch(asyncUserProvider
        .select((selector) => selector.whenData((cb)=>cb.totalSeatsInReserve)));
    final totalSeatsInReserve = uvm;
    return Badge(
      backgroundColor: Colors.green,
      label: Text((totalSeatsInReserve.value ?? 0).toString(),
        style: TextStyle(color: Colors.white, fontSize: screenWidth > 900 ? 16 : 14),),
      isLabelVisible: (totalSeatsInReserve.value ?? 0) == 0 ? false : true,
      child: Icon(iconData, color: color, size: size),
    );
  }
}