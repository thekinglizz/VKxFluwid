import 'dart:convert';

import 'package:flapp_widget/services/post_message_service/dto/post_message_order_dto.dart';

enum PostMessageEventEnum {
  loaded,
  close,
  purchased,
  personalized;

  String get represent => switch (this) {
        PostMessageEventEnum.loaded => 'PartnerWidget__loaded',
        PostMessageEventEnum.close => 'PartnerWidget__close',
        PostMessageEventEnum.purchased => 'PartnerWidget__purchased',
        PostMessageEventEnum.personalized => 'PartnerWidget___personalized',
      };

  static PostMessageEventEnum? fromString(String string) => switch (string) {
        'PartnerWidget__loaded' => PostMessageEventEnum.loaded,
        'PartnerWidget__close' => PostMessageEventEnum.close,
        'PartnerWidget__purchased' => PostMessageEventEnum.purchased,
        'PartnerWidget___personalized' => PostMessageEventEnum.personalized,
        _ => null,
      };
}

abstract class PostMessageEvent {
  PostMessageEventEnum get eventName;
  String get message => jsonEncode({"eventName": eventName.represent});
}

// Loaded Post Message
class PostMessageLoadedEvent implements PostMessageEvent {
  PostMessageLoadedEvent();

  @override
  PostMessageEventEnum get eventName => PostMessageEventEnum.loaded;

  @override
  String get message => jsonEncode({'eventName': eventName.represent});
}

// Close Post Message
class PostMessageCloseEvent implements PostMessageEvent {
  PostMessageCloseEvent();

  @override
  PostMessageEventEnum get eventName => PostMessageEventEnum.close;

  @override
  String get message => jsonEncode({'eventName': eventName.represent});
}

// Purchased Post Message
class PostMessagePurchasedEvent implements PostMessageEvent {
  PostMessagePurchasedEvent({required this.order});

  final PostMessageOrderDto order;

  @override
  PostMessageEventEnum get eventName => PostMessageEventEnum.purchased;

  @override
  String get message => jsonEncode({
        'eventName': eventName.represent,
        'order': order.toJson(),
      });
}
