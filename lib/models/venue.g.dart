// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'venue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Venue _$VenueFromJson(Map<String, dynamic> json) => Venue(
      (json['venueId'] as num).toInt(),
      json['venueName'] as String,
      (json['actionEventList'] as List<dynamic>)
          .map((e) => ActionEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['address'] as String,
    );

Map<String, dynamic> _$VenueToJson(Venue instance) => <String, dynamic>{
      'venueId': instance.venueId,
      'venueName': instance.venueName,
      'address': instance.address,
      'actionEventList':
          instance.actionEventList.map((e) => e.toJson()).toList(),
    };
