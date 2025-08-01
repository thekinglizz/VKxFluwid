import 'dart:convert';
import 'dart:js_interop';
import 'package:flapp_widget/constants.dart';
import 'package:flapp_widget/services/api_service/authorization_service.dart';
import 'package:flapp_widget/services/api_service/dto/request_dto.dart';
import 'package:flapp_widget/services/post_message_service/dto/post_message_personalized_event.dart';
import 'package:flapp_widget/services/post_message_service/post_message_events.dart';
import 'package:flapp_widget/services/post_message_service/widget_settings_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web/web.dart' as web;

//JS Methods
@JS('postMessageFromJS') // Receiver of post message
external set _postMessageFromJS(JSFunction func);

@JS('sendMessageFromDart') // Send post message
external void _postMessage(JSString message, JSString origin);

// Global Provider
final postMessageProvider = Provider<PostMessageService>((ref) {
  throw UnimplementedError('Post Message Provider is not initialized!');
});

class PostMessageService {
  final Ref _ref;
  final String _targetOrigin;

  PostMessageService({
    required Ref ref,
    required String targetOrigin,
  })  : _targetOrigin = targetOrigin,
        _ref = ref {
    // link _messageListener to JS method
    _postMessageFromJS = _onMessageReceived.toJS;

    // Listen kill app action
    // web.window.addEventListener('pagehide', _closeEvent.toJS);
  }

  void post(PostMessageEvent event) =>
      _postMessage(event.message.toJS, _targetOrigin.toJS);

  void _onMessageReceived(JSAny data, JSString origin) {
    if (origin.toDart != _targetOrigin) return;

    try {
      final result = jsonDecode(jsonEncode(data.dartify()));
      final event = PostMessageEventEnum.fromString(result['eventName']);

      switch (event) {
        case PostMessageEventEnum.personalized:
          _onReceivePeronalizedEvent(
            event: PostMessagePersonalizedEvent.fromJson(result),
          );
        case null:
          throw Exception('Received uncorrect postMessage from origin');
        default:
          throw Exception('Received unexpected postMessage from origin');
      }
    } catch (error, stackTrace) {
      print('$error, $stackTrace');
      // TODO - handle error
    }
  }

  // ON Recieved message
  void _onReceivePeronalizedEvent({
    required PostMessagePersonalizedEvent event,
  }) async {
    web.window.alert(
      "Received Personalized Event:\n"
      "userExtra: ${event.extraUser}\n"
      "widgetSettings: ${event.widgetSettings}",
    );

    _ref.read(widgetSettingsProvider.notifier).state = WidgetSettings(
      needCloseButton: event.widgetSettings.needCloseButton ?? false,
    );

    // Authorization processing
    final token = await AuthService.checkJwt(event.extraUser);
    if (token == null) {
      final RequestDTOAuth data = RequestDTOAuth(
        userPayload: RequestDTOUserData(
          providerId: event.extraUser.priorityId,
          providerIdType: event.extraUser.priorityIdType,
          ipAddress: 'ipAddress',
          userAgent: 'userAgent',
        ),
        // TODO -- temporary. Replace with real data
        actionEventPayload: RequestDTOActionEventData(
          actionCoreId: actionId,
          actionName: 'actionName',
          actionEventDateStart: DateTime.now(),
          actionEventDateEnd: DateTime.now(),
          actionEventCoreId: actionEventId,
          ageCategory: 'ageCategory',
          actionCategoryName: 'actionCategoryName',
          venueCoreId: 1234567890,
          venueName: 'venueName',
          address: 'address',
          timeZone: 'timeZone',
          hallName: 'hallName',
          organizatorName: 'organizatorName',
          organizatorAddress: 'organizatorAddress',
          organizatorInn: 'organizatorInn',
        ),
        widgetPayload: RequestDTOWidgetData(
          widgetId: 'widgetId',
          widgetTitle: 'widgetTitle',
          widgetReferer: 'widgetReferer',
          widgetUrl: url?.origin ?? '',
          utmSource: utmSource,
          utmMedium: utmMedium,
          utmCampaign: utmCampaign,
          utmTerm: utmTerm,
          utmContent: utmContent,
        ),
      );

      AuthService.jwt = (await AuthService.login(data: data)).token;
    }

    // get token if authorized before
    if (token != null) {
      AuthService.jwt = token;
    }

    await Future.delayed(const Duration(seconds: 3));

    final ls = await SharedPreferences.getInstance();
    web.window.alert("Keys in local storage : ${ls.getKeys()}");
    web.window.alert("token : $token");
  }
}
