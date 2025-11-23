import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:prime_top_front/core/network/api_client.dart';
import 'package:prime_top_front/core/network/exceptions.dart';
import 'package:prime_top_front/core/network/network_client.dart';
import 'package:prime_top_front/features/data_lake/data/datasources/data_lake_remote_data_source.dart';
import 'package:prime_top_front/features/data_lake/data/models/data_lake_info_model.dart';
import 'package:prime_top_front/features/data_lake/data/models/data_lake_upload_result_model.dart';

class DataLakeRemoteDataSourceImpl implements DataLakeRemoteDataSource {
  DataLakeRemoteDataSourceImpl({
    required NetworkClient networkClient,
    required String baseUrl,
    required String? Function() getAuthToken,
  })  : _apiClient = _DataLakeApiClient(networkClient, baseUrl, getAuthToken);

  final _DataLakeApiClient _apiClient;

  @override
  Future<DataLakeUploadResultModel> uploadDataLakeFile({
    required Uint8List fileBytes,
    required String fileName,
    required String dataType,
  }) async {
    try {
      final path = '/api/admin/data-lake/upload/';
      final url = Uri.parse('${_apiClient.baseUrl}$path');

      final request = http.MultipartRequest('POST', url);

      final token = _apiClient.getAuthToken();
      if (token != null) {
        request.headers['Authorization'] = 'Token $token';
      }

      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          fileBytes,
          filename: fileName,
        ),
      );

      request.fields['data_type'] = dataType;

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 500) {
        throw ServerException(
          'Ошибка сервера',
          statusCode: response.statusCode,
        );
      }

      if (response.statusCode == 401) {
        throw UnauthorizedException('Неверные учетные данные');
      }

      if (response.statusCode == 403) {
        throw UnauthorizedException('Требуются права администратора');
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

      final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
      return DataLakeUploadResultModel.fromJson(responseJson);
    } on NetworkException {
      rethrow;
    } catch (e) {
      if (e is NetworkException) {
        rethrow;
      }
      throw ParseException('Ошибка при загрузке файла: $e');
    }
  }

  @override
  Future<DataLakeInfoModel> getDataLakeInfo() async {
    try {
      final path = '/api/admin/data-lake/info/';
      final response = await _apiClient.get(path);

      return DataLakeInfoModel.fromJson(response);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ParseException('Ошибка при получении информации: $e');
    }
  }
}

class _DataLakeApiClient extends ApiClient {
  _DataLakeApiClient(
    NetworkClient networkClient,
    String baseUrl,
    this._getAuthToken,
  ) : _baseUrl = baseUrl,
       super(networkClient);

  final String _baseUrl;
  final String? Function() _getAuthToken;

  String get baseUrl => _baseUrl;
  String? getAuthToken() => _getAuthToken();

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
  Future<Map<String, dynamic>> patch(
    String url, {
    Map<String, String>? headers,
    Object? body,
  }) {
    return super.patch(_buildUrl(url), headers: _mergeHeaders(headers), body: body);
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
  }

  String _buildUrl(String path) {
    final base = _baseUrl.endsWith('/') ? _baseUrl.substring(0, _baseUrl.length - 1) : _baseUrl;
    final url = path.startsWith('/') ? path : '/$path';
    return '$base$url';
  }

  Map<String, String> _mergeHeaders(Map<String, String>? additionalHeaders) {
    final headers = <String, String>{};
    final token = _getAuthToken();
    if (token != null) {
      headers['Authorization'] = 'Token $token';
    }
    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }
    return headers;
  }
}

