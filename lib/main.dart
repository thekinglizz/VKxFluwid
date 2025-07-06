
import 'package:flapp_widget/ui/screens/acton_mode_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_browser.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'constants.dart';

void main() async {
  //fragmentProgram = await FragmentProgram.fromAsset('shaders/shader.frag');
  WidgetsFlutterBinding.ensureInitialized(); // Обязательно для использования rootBundle
  setPathUrlStrategy();
  findSystemLocale().then((value) {
    Intl.defaultLocale = value;
    if (Uri.base.queryParameters['lng'] != null) {
      if (supportedLng.contains(Uri.base.queryParameters['lng'])) {
        language = Uri.base.queryParameters['lng'];
        Intl.defaultLocale = language;
      }
    }
    runApp(const ProviderScope(observers: [], child: Fluwid()));
  });
}

class Logger extends ProviderObserver {
  @override
  void didUpdateProvider(
      ProviderBase<Object?> provider,
      Object? previousValue,
      Object? newValue,
      ProviderContainer container,
      ) {
    debugPrint('''-{"provider": "${provider.name ?? provider.runtimeType}",
     "newValue": "$newValue"}''');
  }
}