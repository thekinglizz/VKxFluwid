import 'package:json_annotation/json_annotation.dart';

part 'response_dto.g.dart';

@JsonSerializable()
class ResponseDTOAuth {
  final String token;

  ResponseDTOAuth({required this.token});

  factory ResponseDTOAuth.fromJson(Map<String, dynamic> json) =>
      _$ResponseDTOAuthFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseDTOAuthToJson(this);
}
