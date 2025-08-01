// Personalized Post Message
import 'package:flapp_widget/services/api_service/dto/request_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_message_personalized_event.g.dart';

@JsonSerializable()
class PostMessagePersonalizedEvent {
  PostMessagePersonalizedEvent({
    required this.eventName,
    required this.widgetSettings,
    required this.extraUser,
  });

  final String eventName;
  @JsonKey(name: 'widget_settings')
  final PostMessageWidgetSettings widgetSettings;
  @JsonKey(name: 'extra_user')
  final PostMessageExtraUser extraUser;

  factory PostMessagePersonalizedEvent.fromJson(Map<String, dynamic> json) =>
      _$PostMessagePersonalizedEventFromJson(json);

  Map<String, dynamic> toJson() => _$PostMessagePersonalizedEventToJson(this);
}

@JsonSerializable()
class PostMessageWidgetSettings {
  PostMessageWidgetSettings({required this.needCloseButton});

  @JsonKey(name: 'need_close_button')
  final bool? needCloseButton;

  factory PostMessageWidgetSettings.fromJson(Map<String, dynamic> json) =>
      _$PostMessageWidgetSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$PostMessageWidgetSettingsToJson(this);
}

@JsonSerializable()
class PostMessageExtraUser {
  PostMessageExtraUser({
    required this.name,
    required this.email,
    required this.phone,
    required this.vkid,
    required this.uuid,
    required this.okid,
  });

  final String? name;
  final String? email;
  final String? phone;
  @JsonKey(name: 'vk_id')
  final String? vkid;
  @JsonKey(name: 'ok_id')
  final String? okid;
  final String uuid;

  factory PostMessageExtraUser.fromJson(Map<String, dynamic> json) =>
      _$PostMessageExtraUserFromJson(json);

  Map<String, dynamic> toJson() => _$PostMessageExtraUserToJson(this);

  String get priorityId {
    if (vkid != null) return vkid!;
    if (okid != null) return okid!;
    return uuid;
  }

  RequestDtoProviderIdType get priorityIdType {
    if (vkid != null) return RequestDtoProviderIdType.vkid;
    if (okid != null) return RequestDtoProviderIdType.okid;
    return RequestDtoProviderIdType.uuid;
  }
}
