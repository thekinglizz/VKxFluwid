// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_message_order_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostMessageOrderDto _$PostMessageOrderDtoFromJson(Map<String, dynamic> json) =>
    PostMessageOrderDto(
      id: json['id'] as String,
      tickets: (json['tickets'] as List<dynamic>)
          .map((e) => PostMessageTicketDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      sum: (json['sum'] as num).toInt(),
    );

Map<String, dynamic> _$PostMessageOrderDtoToJson(
        PostMessageOrderDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tickets': instance.tickets,
      'sum': instance.sum,
    };

PostMessageTicketDto _$PostMessageTicketDtoFromJson(
        Map<String, dynamic> json) =>
    PostMessageTicketDto(
      sum: (json['sum'] as num).toInt(),
    );

Map<String, dynamic> _$PostMessageTicketDtoToJson(
        PostMessageTicketDto instance) =>
    <String, dynamic>{
      'sum': instance.sum,
    };
