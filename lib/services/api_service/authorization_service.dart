import 'dart:convert';

import 'package:flapp_widget/constants.dart';
import 'package:flapp_widget/services/api_service/dto/request_dto.dart';
import 'package:flapp_widget/services/api_service/dto/response_dto.dart';
import 'package:flapp_widget/services/api_service/jwt_decoder.dart';
import 'package:flapp_widget/services/post_message_service/dto/post_message_personalized_event.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const baseUrl = 'https://vk-widgets-api.dev1.kassirplus.ru/v1';

  // Global jwt variable
  static String? jwt;

  static String _jwtStorageKey(String actEventId, String userId) =>
      "jwt_${actEventId}_$userId";

  static Future<http.Response> _post({
    required String url,
    required Map<String, dynamic> data,
    String? token,
  }) async {
    final headers = {'Content-Type': 'application/json; charset=UTF-8'};
    if (token != null) headers.addAll({'token': token});

    return http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(data),
    );
  }

  static Future<ResponseDTOAuth> login({required RequestDTOAuth data}) async {
    final result = ResponseDTOAuth.fromJson(
      jsonDecode(
        (await _post(url: '$baseUrl/auth/login', data: data.toJson())).body,
      ),
    );

    // Save token to localStorage
    final localStorage = await SharedPreferences.getInstance();
    final localKey = _jwtStorageKey(actionEventId, data.userPayload.providerId);
    localStorage.setString(localKey, result.token);

    jwt = result.token;
    return result;
  }

  static Future<String?> checkJwt(PostMessageExtraUser userExtra) async {
    // get token
    final localStorage = await SharedPreferences.getInstance();
    final tokenKey = _jwtStorageKey(actionEventId, userExtra.priorityId);
    final token = localStorage.getString(tokenKey);

    if (token == null) return null;

    // decode token
    final payload = jwtDecode(token);
    final expDate = DateTime.fromMicrosecondsSinceEpoch(
      payload['exp'],
      isUtc: true,
    );

    // token is fired
    if (DateTime.now().toUtc().isAfter(expDate)) {
      localStorage.remove(tokenKey);
      return null;
    }

    return token;
  }
}
