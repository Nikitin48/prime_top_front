import 'dart:convert';

import 'package:http/http.dart' as http;

import 'exceptions.dart';
import 'network_client.dart';

/// Базовый API клиент с обработкой ошибок
abstract class ApiClient {
  final NetworkClient _client;

  ApiClient(this._client);

  /// Выполняет GET запрос
  Future<Map<String, dynamic>> get(
    String url, {
    Map<String, String>? headers,
  }) async {
    return _handleResponse(await _client.get(url, headers: headers));
  }

  /// Выполняет POST запрос
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

  /// Выполняет PUT запрос
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

  /// Выполняет DELETE запрос
  Future<Map<String, dynamic>> delete(
    String url, {
    Map<String, String>? headers,
  }) async {
    return _handleResponse(await _client.delete(url, headers: headers));
  }

  /// Обрабатывает HTTP ответ
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
        // Если не удалось распарсить, используем дефолтное сообщение
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
      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      throw ParseException('Не удалось распарсить ответ сервера: $e');
    }
  }

  /// Устанавливает токен авторизации
  void setAuthToken(String? token);
}

