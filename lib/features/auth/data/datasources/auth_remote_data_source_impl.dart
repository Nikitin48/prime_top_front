import 'package:prime_top_front/core/network/api_client.dart';
import 'package:prime_top_front/core/network/exceptions.dart';
import 'package:prime_top_front/core/network/network_client.dart';
import 'package:prime_top_front/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:prime_top_front/features/auth/data/models/user_model.dart';

/// Реализация удаленного источника данных авторизации
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({
    required NetworkClient networkClient,
    required String baseUrl,
  }) : _apiClient = _AuthApiClient(networkClient, baseUrl);

  final _AuthApiClient _apiClient;

  @override
  Future<UserModel> register({
    required String email,
    required String password,
    required String clientName,
    required String clientEmail,
  }) async {
    try {
      final body = {
        'email': email.toLowerCase(),
        'password': password,
        'client_name': clientName,
        'client_email': clientEmail.toLowerCase(),
      };

      final response = await _apiClient.post('/api/auth/register/', body: body);

      final userJson = response['user'] as Map<String, dynamic>?;
      if (userJson == null) {
        throw ParseException('Отсутствует поле user в ответе сервера');
      }
      final user = UserModel.fromJson({
        ...userJson,
        'token': response['token'] as String?,
        'expires_in': response['expires_in'] as int?,
      });
      if (user.token != null) {
        _apiClient.setAuthToken(user.token);
      }
      return user;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ParseException('Ошибка при регистрации: $e');
    }
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final body = {
        'email': email.toLowerCase(),
        'password': password,
      };

      final response = await _apiClient.post('/api/auth/login/', body: body);

      final userJson = response['user'] as Map<String, dynamic>?;
      if (userJson == null) {
        throw ParseException('Отсутствует поле user в ответе сервера');
      }
      final user = UserModel.fromJson({
        ...userJson,
        'token': response['token'] as String?,
        'expires_in': response['expires_in'] as int?,
      });
      if (user.token != null) {
        _apiClient.setAuthToken(user.token);
      }
      return user;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ParseException('Ошибка при входе: $e');
    }
  }

  @override
  Future<void> logout() async {
    _apiClient.setAuthToken(null);
  }

  @override
  void restoreToken(String? token) {
    _apiClient.setAuthToken(token);
  }
}

/// Внутренний API клиент для авторизации
class _AuthApiClient extends ApiClient {
  _AuthApiClient(NetworkClient networkClient, String baseUrl)
      : _baseUrl = baseUrl,
        super(networkClient);

  final String _baseUrl;
  String? _authToken;

  @override
  Future<Map<String, dynamic>> get(
    String url, {
    Map<String, String>? headers,
  }) {
    return super.get(_buildUrl(url), headers: _mergeHeaders(headers));
  }

  @override
  Future<Map<String, dynamic>> post(
    String url, {
    Map<String, String>? headers,
    Object? body,
  }) {
    return super.post(_buildUrl(url), headers: _mergeHeaders(headers), body: body);
  }

  @override
  Future<Map<String, dynamic>> put(
    String url, {
    Map<String, String>? headers,
    Object? body,
  }) {
    return super.put(_buildUrl(url), headers: _mergeHeaders(headers), body: body);
  }

  @override
  Future<Map<String, dynamic>> delete(
    String url, {
    Map<String, String>? headers,
  }) {
    return super.delete(_buildUrl(url), headers: _mergeHeaders(headers));
  }

  @override
  void setAuthToken(String? token) {
    _authToken = token;
  }

  String _buildUrl(String path) {
    final base = _baseUrl.endsWith('/') ? _baseUrl.substring(0, _baseUrl.length - 1) : _baseUrl;
    final url = path.startsWith('/') ? path : '/$path';
    return '$base$url';
  }

  Map<String, String> _mergeHeaders(Map<String, String>? additionalHeaders) {
    final headers = <String, String>{};
    if (_authToken != null) {
      headers['Authorization'] = 'Token $_authToken';
    }
    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }
    return headers;
  }
}

