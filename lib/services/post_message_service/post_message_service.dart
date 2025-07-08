import 'dart:convert';
import 'dart:js_interop';

@JS('sendMessageFromDart')
external void _postMessage(JSString message, JSString origin);

class PostMessageService {
  static late final String targetOrigin;

  static void loadedEvent() {
    const eventName = "PartnerWidget__loaded";

    _postMessage(
      jsonEncode({eventName: eventName}).toJS,
      targetOrigin.toJS,
    );
  }

  static void closeEvent() {
    const eventName = "PartnerWidget_Close";

    _postMessage(
      '{ eventName: "$eventName" }'.toJS,
      targetOrigin.toJS,
    );
  }

  static void purchasedEvent({required Object order}) {
    const eventName = "PartnerWidget__purchased";

    _postMessage(
      '{ eventName: "$eventName" }'.toJS,
      targetOrigin.toJS,
    );
  }
}
