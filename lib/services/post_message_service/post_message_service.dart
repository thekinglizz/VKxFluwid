import 'dart:convert';
import 'dart:js_interop';
import 'package:web/web.dart' as web;

import 'package:flapp_widget/services/post_message_service/post_message_order_dto.dart';

// Send post message
@JS('sendMessageFromDart')
external void _postMessage(JSString message, JSString origin);

// Receiver of post message
@JS('postMessageFromJS')
external set _postMessageFromJS(JSFunction func);

// Message converter to post message service function
void _messageListener(JSAny data, JSString origin) =>
    PostMessageService.handleMessage(data.dartify(), origin.toDart);

// Post Messagees Service class
class PostMessageService {
  // Target origin (origin of parent window, where flutter is iframe)
  static late final String targetOrigin;

  // init service, set origin and start listen messages
  static serviceInit({required String origin}) {
    targetOrigin = origin;
    _postMessageFromJS = _messageListener.toJS;
  }

  // Perform listened message from js
  static handleMessage(dynamic data, String origin) {
    if (origin != targetOrigin) return;

    // Hangle message
    web.window.alert("From $origin reveived message: ${data["id"]}");
  }

  // Post Message ACTIONS
  static void loadedEvent() {
    const eventName = "PartnerWidget__loaded";

    _postMessage(
      jsonEncode({"eventName": eventName}).toJS,
      targetOrigin.toJS,
    );
  }

  static void closeEvent() {
    const eventName = "PartnerWidget_Close";

    _postMessage(
      jsonEncode({"eventName": eventName}).toJS,
      targetOrigin.toJS,
    );
  }

  static void purchasedEvent({required PostMessageOrderDto order}) {
    const eventName = "PartnerWidget__purchased";

    _postMessage(
      jsonEncode({"eventName": eventName, order: order.toJson()}).toJS,
      targetOrigin.toJS,
    );
  }
}
