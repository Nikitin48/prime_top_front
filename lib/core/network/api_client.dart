import 'dart:convert';

import 'package:http/http.dart' as http;

import 'exceptions.dart';
import 'network_client.dart';

abstract class ApiClient {
  final NetworkClient _client;

  ApiClient(this._client);

  Future<Map<String, dynamic>> get(
    String url, {
    Map<String, String>? headers,
  }) async {
    return _handleResponse(await _client.get(url, headers: headers));
  }

  Future<Map<String, dynamic>> post(
    String url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final jsonBody = body is Map || body is List ? jsonEncode(body) : body;
    final requestHeaders = {
      'Content-Type': 'application/json',
      ...?headers,
    };
    return _handleResponse(await _client.post(url, headers: requestHeaders, body: jsonBody));
  }

  Future<Map<String, dynamic>> put(
    String url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final jsonBody = body is Map || body is List ? jsonEncode(body) : body;
    final requestHeaders = {
      'Content-Type': 'application/json',
      ...?headers,
    };
    return _handleResponse(await _client.put(url, headers: requestHeaders, body: jsonBody));
  }

  Future<Map<String, dynamic>> patch(
    String url, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    final jsonBody = body is Map || body is List ? jsonEncode(body) : body;
    final requestHeaders = {
      'Content-Type': 'application/json',
      ...?headers,
    };
    return _handleResponse(await _client.patch(url, headers: requestHeaders, body: jsonBody));
  }

  Future<Map<String, dynamic>> delete(
    String url, {
    Map<String, String>? headers,
  }) async {
    return _handleResponse(await _client.delete(url, headers: headers));
  }

  Future<Map<String, dynamic>> _handleResponse(http.Response response) async {
    if (response.statusCode >= 500) {
      throw ServerException(
        'Ошибка сервера',
        statusCode: response.statusCode,
      );
    }

    if (response.statusCode == 401) {
      throw UnauthorizedException('Неверные учетные данные');
    }

    if (response.statusCode == 409) {
      throw ConflictException('Конфликт данных');
    }

    if (response.statusCode >= 400) {
      String errorMessage = 'Ошибка запроса';
      try {
        final errorBody = jsonDecode(response.body) as Map<String, dynamic>;
        if (errorBody.containsKey('error')) {
          errorMessage = errorBody['error'] as String;
        } else if (errorBody.containsKey('message')) {
          errorMessage = errorBody['message'] as String;
        } else if (errorBody.containsKey('detail')) {
          errorMessage = errorBody['detail'] as String;
        }
      } catch (_) {
      }
      throw ClientException(
        errorMessage,
        statusCode: response.statusCode,
      );
    }

    if (response.body.isEmpty) {
      return {};
    }

    try {
      final decoded = jsonDecode(response.body);
      if (decoded == null) {
        return {};
      }
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      throw ParseException('Ответ сервера не является объектом JSON');
    } catch (e) {
      if (e is ParseException) {
        rethrow;
      }
      throw ParseException('Не удалось распарсить ответ сервера: $e');
    }
  }

  void setAuthToken(String? token);
}
