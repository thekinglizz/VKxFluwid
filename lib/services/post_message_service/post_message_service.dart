import 'dart:js_interop';
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

  void _onMessageReceived(JSAny data, JSString origin) {
    if (origin.toDart != _targetOrigin) return;

    final result = data.dartify();

    web.window.alert("From $origin reveived message: $result");
  }

  void _closeEvent() => post(PostMessageCloseEvent());
}
