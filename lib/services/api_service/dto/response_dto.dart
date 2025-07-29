import 'package:json_annotation/json_annotation.dart';

part 'response_dto.g.dart';

@JsonSerializable()
class ReponseDTOAuth {
  final String token;

  ReponseDTOAuth({required this.token});

  factory ReponseDTOAuth.fromJson(Map<String, dynamic> json) =>
      _$ReponseDTOAuthFromJson(json);
      
  Map<String, dynamic> toJson() => _$ReponseDTOAuthToJson(this);
}
