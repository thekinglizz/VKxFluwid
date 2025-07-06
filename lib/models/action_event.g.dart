// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActionEvent _$ActionEventFromJson(Map<String, dynamic> json) => ActionEvent(
      (json['actionEventId'] as num).toInt(),
      json['day'] as String,
      json['time'] as String,
      json['currency'] as String,
      json['placementUrl'] as String?,
      json['tariffPlanList'] as List<dynamic>,
      (json['categoryLimitList'] as List<dynamic>)
          .map((e) => CategoryLimit.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['fullNameRequired'] as bool,
      json['phoneRequired'] as bool,
      json['fanIdRequired'] as bool,
    );

Map<String, dynamic> _$ActionEventToJson(ActionEvent instance) =>
    <String, dynamic>{
      'actionEventId': instance.actionEventId,
      'day': instance.day,
      'time': instance.time,
      'currency': instance.currency,
      'fullNameRequired': instance.fullNameRequired,
      'phoneRequired': instance.phoneRequired,
      'fanIdRequired': instance.fanIdRequired,
      'placementUrl': instance.placementUrl,
      'tariffPlanList': instance.tariffPlanList,
      'categoryLimitList':
          instance.categoryLimitList.map((e) => e.toJson()).toList(),
    };
