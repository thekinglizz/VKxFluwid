import 'package:json_annotation/json_annotation.dart';

part 'request_dto.g.dart';

// *** AUTH REQUEST ***
@JsonSerializable()
class RequestDTOAuth {
  @JsonKey(name: 'user_payload')
  final RequestDTOUserData userPayload;
  @JsonKey(name: 'widget_payload')
  final RequestDTOWidgetData widgetPayload;
  @JsonKey(name: 'action_event_payload')
  final RequestDTOActionEventData actionEventPayload;

  RequestDTOAuth({
    required this.userPayload,
    required this.actionEventPayload,
    required this.widgetPayload,
  });

  factory RequestDTOAuth.fromJson(Map<String, dynamic> json) =>
      _$RequestDTOAuthFromJson(json);

  Map<String, dynamic> toJson() => _$RequestDTOAuthToJson(this);
}

enum RequestDtoProviderIdType {
  vkid,
  okid,
  uuid;

  String get represent => switch (this) {
        vkid => "VK_ID",
        okid => "OK_ID",
        uuid => "UUID",
      };

  static RequestDtoProviderIdType fromString(String str) => switch (str) {
        "VK_ID" => RequestDtoProviderIdType.vkid,
        "OK_ID" => RequestDtoProviderIdType.okid,
        "UUID" => RequestDtoProviderIdType.uuid,
        _ => RequestDtoProviderIdType.uuid,
      };
}

@JsonSerializable(includeIfNull: false)
class RequestDTOUserData {
  RequestDTOUserData({
    required this.providerId,
    required this.providerIdType,
    required this.ipAddress,
    required this.userAgent,
    this.name,
    this.email,
    this.phone,
  });

  @JsonKey(name: 'provider_id')
  final String providerId;
  @JsonKey(
    name: 'provider_id_type',
    fromJson: RequestDtoProviderIdType.fromString,
    toJson: _providerIdTypeToJson,
  )
  final RequestDtoProviderIdType providerIdType;
  @JsonKey(name: 'ip_address')
  final String ipAddress;
  @JsonKey(name: 'user_agent')
  final String userAgent;
  final String? name;
  final String? email;
  final String? phone;

  factory RequestDTOUserData.fromJson(Map<String, dynamic> json) =>
      _$RequestDTOUserDataFromJson(json);

  Map<String, dynamic> toJson() => _$RequestDTOUserDataToJson(this);

  static String _providerIdTypeToJson(RequestDtoProviderIdType type) =>
      type.represent;
}

@JsonSerializable(includeIfNull: false)
class RequestDTOWidgetData {
  RequestDTOWidgetData({
    required this.widgetId,
    required this.widgetTitle,
    required this.widgetReferer,
    required this.widgetUrl,
    this.utmSource,
    this.utmMedium,
    this.utmCampaign,
    this.utmTerm,
    this.utmContent,
  });

  @JsonKey(name: 'widget_id')
  final String widgetId;
  @JsonKey(name: 'widget_title')
  final String widgetTitle;
  @JsonKey(name: 'widget_referer')
  final String widgetReferer;
  @JsonKey(name: 'widget_url')
  final String widgetUrl;
  @JsonKey(name: 'utm_source')
  final String? utmSource;
  @JsonKey(name: 'utm_medium')
  final String? utmMedium;
  @JsonKey(name: 'utm_campaign')
  final String? utmCampaign;
  @JsonKey(name: 'utm_term')
  final String? utmTerm;
  @JsonKey(name: 'utm_content')
  final String? utmContent;

  factory RequestDTOWidgetData.fromJson(Map<String, dynamic> json) =>
      _$RequestDTOWidgetDataFromJson(json);

  Map<String, dynamic> toJson() => _$RequestDTOWidgetDataToJson(this);
}

@JsonSerializable(includeIfNull: false)
class RequestDTOActionEventData {
  RequestDTOActionEventData({
    required this.actionCoreId,
    required this.actionName,
    required this.actionEventDateStart,
    required this.actionEventDateEnd,
    required this.actionEventCoreId,
    required this.ageCategory,
    required this.actionCategoryName,
    required this.venueCoreId,
    required this.venueName,
    this.region,
    this.city,
    required this.address,
    required this.timeZone,
    required this.hallName,
    required this.organizatorName,
    required this.organizatorAddress,
    required this.organizatorInn,
    this.kdpKode,
  });

  // ID мероприятия в core
  @JsonKey(name: 'action_core_id')
  final int actionCoreId;
  // Название мероприятия
  @JsonKey(name: 'action_name')
  final String actionName;
  // Время начала события в часовой зоне места проведения
  @JsonKey(name: 'action_event_date_start')
  final DateTime actionEventDateStart;
  // Время окончания события в часовой зоне места проведения
  @JsonKey(name: 'action_event_date_end')
  final DateTime actionEventDateEnd;
  // ID события в core
  @JsonKey(name: 'action_event_core_id')
  final int actionEventCoreId;
  // Возрастная категория
  @JsonKey(name: 'age_category')
  final String ageCategory;
  // Название категории мероприятия
  @JsonKey(name: 'action_category_name')
  final String actionCategoryName;
  // ID площадки в core
  @JsonKey(name: 'venue_core_id')
  final int venueCoreId;
  // Название площадки
  @JsonKey(name: 'venue_name')
  final String venueName;
  // Регион
  final String? region;
  // Город
  final String? city;
  // Полный адрес, включая название населенного пункта
  final String address;
  // Часовой пояс
  @JsonKey(name: 'time_zone')
  final String timeZone;
  // Название зала
  @JsonKey(name: 'hall_name')
  final String hallName;
  // Организатор
  @JsonKey(name: 'organizator_name')
  final String organizatorName;
  // Юридический адрес организатора
  @JsonKey(name: 'organizator_address')
  final String organizatorAddress;
  // ИНН организатора
  @JsonKey(name: 'organizator_inn')
  final String organizatorInn;
  // Код доступа к мероприятию
  @JsonKey(name: 'kdp_kode')
  final String? kdpKode;

  factory RequestDTOActionEventData.fromJson(Map<String, dynamic> json) =>
      _$RequestDTOActionEventDataFromJson(json);

  Map<String, dynamic> toJson() => _$RequestDTOActionEventDataToJson(this);
}
