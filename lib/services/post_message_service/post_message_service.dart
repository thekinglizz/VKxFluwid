import 'dart:convert';
import 'dart:js_interop';
import 'package:flapp_widget/services/post_message_service/dto/post_message_personalized_event.dart';
import 'package:flapp_widget/services/post_message_service/post_message_events.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  final String _targetOrigin;

  PostMessageService({required String targetOrigin})
      : _targetOrigin = targetOrigin {
    // link _messageListener to JS method
    _postMessageFromJS = _onMessageReceived.toJS;

    // Listen kill app action
    web.window.addEventListener('pagehide', _closeEvent.toJS);
  }

  void post(PostMessageEvent event) =>
      _postMessage(event.message.toJS, _targetOrigin.toJS);

  void _closeEvent() => post(PostMessageCloseEvent());

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
    }
  }

  // ON Recieved message
  void _onReceivePeronalizedEvent({
    required PostMessagePersonalizedEvent event,
  }) {
    web.window.alert(
      "Received Personalized Event:\n"
      "userExtra: ${event.extraUser}\n"
      "widgetSettings: ${event.widgetSettings}",
    );
  }
}
