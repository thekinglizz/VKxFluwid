import 'dart:convert';
import 'dart:js_interop';

import 'package:flapp_widget/services/post_message_service/post_message_order_dto.dart';

@JS('sendMessageFromDart')
external void _postMessage(JSString message, JSString origin);

class PostMessageService {
  static late final String targetOrigin;

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
