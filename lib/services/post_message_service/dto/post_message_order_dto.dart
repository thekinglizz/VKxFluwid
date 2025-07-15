import 'package:json_annotation/json_annotation.dart';

part 'post_message_order_dto.g.dart';

@JsonSerializable()
class PostMessageOrderDto {
  final String id;
  final List<PostMessageTicketDto> tickets;
  final int sum;

  PostMessageOrderDto(
      {required this.id, required this.tickets, required this.sum});

  factory PostMessageOrderDto.fromJson(Map<String, dynamic> json) =>
      _$PostMessageOrderDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PostMessageOrderDtoToJson(this);
}

@JsonSerializable()
class PostMessageTicketDto {
  int sum;

  PostMessageTicketDto({required this.sum});

  factory PostMessageTicketDto.fromJson(Map<String, dynamic> json) =>
      _$PostMessageTicketDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PostMessageTicketDtoToJson(this);
}
