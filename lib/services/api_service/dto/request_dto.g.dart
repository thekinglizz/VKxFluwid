// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestDTOAuth _$RequestDTOAuthFromJson(Map<String, dynamic> json) =>
    RequestDTOAuth(
      userPayload: RequestDTOUserData.fromJson(
          json['user_payload'] as Map<String, dynamic>),
      actionEventPayload: RequestDTOActionEventData.fromJson(
          json['action_event_payload'] as Map<String, dynamic>),
      widgetPayload: RequestDTOWidgetData.fromJson(
          json['widget_payload'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RequestDTOAuthToJson(RequestDTOAuth instance) =>
    <String, dynamic>{
      'user_payload': instance.userPayload,
      'widget_payload': instance.widgetPayload,
      'action_event_payload': instance.actionEventPayload,
    };

RequestDTOUserData _$RequestDTOUserDataFromJson(Map<String, dynamic> json) =>
    RequestDTOUserData(
      providerId: json['provider_id'] as String,
      providerIdType: RequestDtoProviderIdType.fromString(
          json['provider_id_type'] as String),
      ipAddress: json['ip_address'] as String,
      userAgent: json['user_agent'] as String,
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$RequestDTOUserDataToJson(RequestDTOUserData instance) {
  final val = <String, dynamic>{
    'provider_id': instance.providerId,
    'provider_id_type':
        RequestDTOUserData._providerIdTypeToJson(instance.providerIdType),
    'ip_address': instance.ipAddress,
    'user_agent': instance.userAgent,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('name', instance.name);
  writeNotNull('email', instance.email);
  writeNotNull('phone', instance.phone);
  return val;
}

RequestDTOWidgetData _$RequestDTOWidgetDataFromJson(
        Map<String, dynamic> json) =>
    RequestDTOWidgetData(
      widgetId: json['widget_id'] as String,
      widgetTitle: json['widget_title'] as String,
      widgetReferer: json['widget_referer'] as String,
      widgetUrl: json['widget_url'] as String,
      utmSource: json['utm_source'] as String?,
      utmMedium: json['utm_medium'] as String?,
      utmCampaign: json['utm_campaign'] as String?,
      utmTerm: json['utm_term'] as String?,
      utmContent: json['utm_content'] as String?,
    );

Map<String, dynamic> _$RequestDTOWidgetDataToJson(
    RequestDTOWidgetData instance) {
  final val = <String, dynamic>{
    'widget_id': instance.widgetId,
    'widget_title': instance.widgetTitle,
    'widget_referer': instance.widgetReferer,
    'widget_url': instance.widgetUrl,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('utm_source', instance.utmSource);
  writeNotNull('utm_medium', instance.utmMedium);
  writeNotNull('utm_campaign', instance.utmCampaign);
  writeNotNull('utm_term', instance.utmTerm);
  writeNotNull('utm_content', instance.utmContent);
  return val;
}

RequestDTOActionEventData _$RequestDTOActionEventDataFromJson(
        Map<String, dynamic> json) =>
    RequestDTOActionEventData(
      actionCoreId: (json['action_core_id'] as num).toInt(),
      actionName: json['action_name'] as String,
      actionEventDateStart:
          DateTime.parse(json['action_event_date_start'] as String),
      actionEventDateEnd:
          DateTime.parse(json['action_event_date_end'] as String),
      actionEventCoreId: (json['action_event_core_id'] as num).toInt(),
      ageCategory: json['age_category'] as String,
      actionCategoryName: json['action_category_name'] as String,
      venueCoreId: (json['venue_core_id'] as num).toInt(),
      venueName: json['venue_name'] as String,
      region: json['region'] as String?,
      city: json['city'] as String?,
      address: json['address'] as String,
      timeZone: json['time_zone'] as String,
      hallName: json['hall_name'] as String,
      organizatorName: json['organizator_name'] as String,
      organizatorAddress: json['organizator_address'] as String,
      organizatorInn: json['organizator_inn'] as String,
      kdpKode: json['kdp_kode'] as String?,
    );

Map<String, dynamic> _$RequestDTOActionEventDataToJson(
    RequestDTOActionEventData instance) {
  final val = <String, dynamic>{
    'action_core_id': instance.actionCoreId,
    'action_name': instance.actionName,
    'action_event_date_start': instance.actionEventDateStart.toIso8601String(),
    'action_event_date_end': instance.actionEventDateEnd.toIso8601String(),
    'action_event_core_id': instance.actionEventCoreId,
    'age_category': instance.ageCategory,
    'action_category_name': instance.actionCategoryName,
    'venue_core_id': instance.venueCoreId,
    'venue_name': instance.venueName,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('region', instance.region);
  writeNotNull('city', instance.city);
  val['address'] = instance.address;
  val['time_zone'] = instance.timeZone;
  val['hall_name'] = instance.hallName;
  val['organizator_name'] = instance.organizatorName;
  val['organizator_address'] = instance.organizatorAddress;
  val['organizator_inn'] = instance.organizatorInn;
  writeNotNull('kdp_kode', instance.kdpKode);
  return val;
}
