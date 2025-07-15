import 'dart:convert';

import 'package:flapp_widget/services/post_message_service/dto/post_message_order_dto.dart';

abstract class PostMessageEvent {
  String get _eventName;
  String get message => jsonEncode({"eventName": _eventName});
}

// Loaded Post Message
class PostMessageLoadedEvent implements PostMessageEvent {
  PostMessageLoadedEvent();

  @override
  String get _eventName => 'PartnerEvent__loaded';

  @override
  String get message => jsonEncode({"eventName": _eventName});
}

// Close Post Message
class PostMessageCloseEvent implements PostMessageEvent {
  PostMessageCloseEvent();

  @override
  String get _eventName => 'PartnerEvent__close';

  @override
  String get message => jsonEncode({"eventName": _eventName});
}

// Purchased Post Message
class PostMessagePurchasedEvent implements PostMessageEvent {
  PostMessagePurchasedEvent({required this.order});

  final PostMessageOrderDto order;

  @override
  String get _eventName => 'PartnerEvent_Close';

  @override
  String get message => jsonEncode({
        "eventName": _eventName,
        "order": order.toJson(),
      });
}
