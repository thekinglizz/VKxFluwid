import 'dart:convert' as convert;

Map<String, dynamic> jwtDecode(String token) {
  try {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw const FormatException('Invalid JWT token format');
    }

    final payload = parts[1];

    String normalizedPayload = payload.replaceAll('-', '+').replaceAll('_', '/');
    final paddingLength = 4 - (normalizedPayload.length % 4);
    if (paddingLength <= 2) {
      normalizedPayload += '=' * paddingLength;
    }

    final decodedBytes = convert.base64Url.decode(normalizedPayload);
    final decodedString = convert.utf8.decode(decodedBytes);

    return convert.jsonDecode(decodedString);
  } catch (e) {
    throw FormatException('Failed to decode JWT payload: $e');
  }
}