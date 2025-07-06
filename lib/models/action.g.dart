// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Action _$ActionFromJson(Map<String, dynamic> json) => Action(
      (json['actionId'] as num).toInt(),
      (json['cityId'] as num).toInt(),
      json['age'] as String,
      json['kdp'] as bool,
      json['legalOwnerName'] as String,
      json['actionName'] as String,
      json['fullActionName'] as String,
      json['smallPosterUrl'] as String,
      json['bigPosterUrl'] as String,
      json['description'] as String,
      (json['venueList'] as List<dynamic>)
          .map((e) => Venue.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ActionToJson(Action instance) => <String, dynamic>{
      'actionId': instance.actionId,
      'cityId': instance.cityId,
      'age': instance.age,
      'kdp': instance.kdp,
      'legalOwnerName': instance.legalOwnerName,
      'actionName': instance.actionName,
      'fullActionName': instance.fullActionName,
      'smallPosterUrl': instance.smallPosterUrl,
      'bigPosterUrl': instance.bigPosterUrl,
      'description': instance.description,
      'venueList': instance.venueList.map((e) => e.toJson()).toList(),
    };
