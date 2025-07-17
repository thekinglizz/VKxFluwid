import 'package:flutter_riverpod/flutter_riverpod.dart';

final widgetSettingsProvider = StateProvider<WidgetSettings>(
  (ref) => WidgetSettings(),
);

class WidgetSettings {
  WidgetSettings({
    this.needCloseButton = false,
  });

  final bool needCloseButton;
}
