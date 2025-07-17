import 'dart:ui';

import 'package:animations/animations.dart';
import 'package:flapp_widget/constants.dart';
import 'package:flapp_widget/i18n/app_localizations.dart';
import 'package:flapp_widget/services/post_message_service/post_message_events.dart';
import 'package:flapp_widget/services/post_message_service/post_message_service.dart';
import 'package:flapp_widget/services/post_message_service/widget_settings_provider.dart';
import 'package:flapp_widget/styles/ui_styles.dart';
import 'package:flapp_widget/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CloseWidgetButton extends ConsumerWidget {
  const CloseWidgetButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showButton = ref.watch(widgetSettingsProvider).needCloseButton;

    if (!showButton) return const SizedBox.shrink();

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          final result = await _CloseModalWidget._showCloseWidgetModal(context);
          if (result == true) {
            ref.read(postMessageProvider).post(PostMessageCloseEvent());
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            CupertinoIcons.clear,
            size: 36.0,
            color: MaterialTheme.lightScheme().onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _CloseModalWidget extends StatelessWidget {
  static Future<bool?> _showCloseWidgetModal(BuildContext context) =>
      showModal<bool?>(
        context: context,
        configuration: const FadeScaleTransitionConfiguration(
            reverseTransitionDuration: Duration(milliseconds: 300),
            transitionDuration: Duration(milliseconds: 300)),
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Center(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    controller: ScrollController(),
                    child: Card(
                      color: const Color(0xfff2f3f5),
                      margin: EdgeInsets.zero,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: _CloseModalWidget(),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8.0,
                    right: 8.0,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context, false),
                        child: Icon(
                          CupertinoIcons.clear_thick_circled,
                          size: 26,
                          color: MaterialTheme.lightScheme().tertiary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width >= 1100;

    return SizedBox(
      width: 280.0,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              CupertinoIcons.exclamationmark_triangle,
              size: 80,
              color: MaterialTheme.lightScheme().onSurfaceVariant,
            ),
            const SizedBox(height: 16.0),
            Text(
              AppLocalizations.of(context)!.closeWidgetMessage,
              textAlign: TextAlign.center,
              style: customTextStyle(
                MaterialTheme.lightScheme().onSurfaceVariant,
                screenWidth > 900 ? 16 : 14,
                'Regular',
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Yes
                FilledButton(
                  style: customRoundedBorderStyle(
                    MaterialTheme.lightScheme().primary,
                  ),
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(
                    AppLocalizations.of(context)!.closeWidgetYesButton,
                    style: customTextStyle(
                      Colors.white,
                      isDesktop ? 20.0 : 18.0,
                      'Regular',
                    ),
                  ),
                ),
                const SizedBox(width: 20),

                // No
                FilledButton(
                  style: customRoundedBorderStyle(
                    MaterialTheme.lightScheme().onSurface,
                  ),
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(
                    AppLocalizations.of(context)!.closeWidgetNoButton,
                    style: customTextStyle(
                      Colors.white,
                      isDesktop ? 20.0 : 18.0,
                      'Regular',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
