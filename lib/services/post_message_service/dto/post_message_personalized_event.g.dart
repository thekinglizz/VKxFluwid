// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_message_personalized_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostMessagePersonalizedEvent _$PostMessagePersonalizedEventFromJson(
        Map<String, dynamic> json) =>
    PostMessagePersonalizedEvent(
      eventName: json['eventName'] as String,
      widgetSettings: PostMessageWidgetSettings.fromJson(
          json['widget_settings'] as Map<String, dynamic>),
      extraUser: PostMessageExtraUser.fromJson(
          json['extra_user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PostMessagePersonalizedEventToJson(
        PostMessagePersonalizedEvent instance) =>
    <String, dynamic>{
      'eventName': instance.eventName,
      'widget_settings': instance.widgetSettings,
      'extra_user': instance.extraUser,
    };

PostMessageWidgetSettings _$PostMessageWidgetSettingsFromJson(
        Map<String, dynamic> json) =>
    PostMessageWidgetSettings(
      needCloseButton: json['need_close_button'] as bool?,
    );

Map<String, dynamic> _$PostMessageWidgetSettingsToJson(
        PostMessageWidgetSettings instance) =>
    <String, dynamic>{
      'need_close_button': instance.needCloseButton,
    };

PostMessageExtraUser _$PostMessageExtraUserFromJson(
        Map<String, dynamic> json) =>
    PostMessageExtraUser(
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      vkid: json['vk_id'] as String?,
      uuid: json['uuid'] as String,
      okid: json['ok_id'] as String?,
    );

Map<String, dynamic> _$PostMessageExtraUserToJson(
        PostMessageExtraUser instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'vk_id': instance.vkid,
      'ok_id': instance.okid,
      'uuid': instance.uuid,
    };
