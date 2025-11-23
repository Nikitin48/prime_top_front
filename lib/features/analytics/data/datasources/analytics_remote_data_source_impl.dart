import 'package:prime_top_front/core/network/api_client.dart';
import 'package:prime_top_front/core/network/exceptions.dart';
import 'package:prime_top_front/core/network/network_client.dart';
import 'analytics_remote_data_source.dart';
import '../models/top_products_model.dart';
import '../models/top_series_model.dart';
import '../models/top_coating_types_model.dart';

class AnalyticsRemoteDataSourceImpl implements AnalyticsRemoteDataSource {
  AnalyticsRemoteDataSourceImpl({
    required NetworkClient networkClient,
    required String baseUrl,
    required String? Function() getAuthToken,
  })  : _apiClient = _AnalyticsApiClient(networkClient, baseUrl, getAuthToken);

  final _AnalyticsApiClient _apiClient;

  @override
  Future<TopProductsModel> getTopProducts({
    String? createdFrom,
    String? createdTo,
    int? clientId,
    int? coatingTypeId,
    int limit = 10,
  }) async {
    try {
      final queryParams = <String, String>{
        'limit': limit.toString(),
      };
      if (createdFrom != null) {
        queryParams['created_from'] = createdFrom;
      }
      if (createdTo != null) {
        queryParams['created_to'] = createdTo;
      }
      if (clientId != null) {
        queryParams['client_id'] = clientId.toString();
      }
      if (coatingTypeId != null) {
        queryParams['coating_type_id'] = coatingTypeId.toString();
      }

      final queryString = queryParams.isEmpty
          ? ''
          : '?${queryParams.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&')}';

      final path = '/api/admin/analytics/top-products/$queryString'.replaceAll('//', '/');
      final response = await _apiClient.get(path);

      return TopProductsModel.fromJson(response);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ParseException('Ошибка при получении топ продуктов: $e');
    }
  }

  @override
  Future<TopSeriesModel> getTopSeries({
    String? createdFrom,
    String? createdTo,
    int? clientId,
    int limit = 10,
  }) async {
    try {
      final queryParams = <String, String>{
        'limit': limit.toString(),
      };
      if (createdFrom != null) {
        queryParams['created_from'] = createdFrom;
      }
      if (createdTo != null) {
        queryParams['created_to'] = createdTo;
      }
      if (clientId != null) {
        queryParams['client_id'] = clientId.toString();
      }

      final queryString = queryParams.isEmpty
          ? ''
          : '?${queryParams.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&')}';

      final path = '/api/admin/analytics/top-series/$queryString'.replaceAll('//', '/');
      final response = await _apiClient.get(path);

      return TopSeriesModel.fromJson(response);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ParseException('Ошибка при получении топ серий: $e');
    }
  }

  @override
  Future<TopCoatingTypesModel> getTopCoatingTypes({
    String? createdFrom,
    String? createdTo,
    int? clientId,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (createdFrom != null) {
        queryParams['created_from'] = createdFrom;
      }
      if (createdTo != null) {
        queryParams['created_to'] = createdTo;
      }
      if (clientId != null) {
        queryParams['client_id'] = clientId.toString();
      }

      final queryString = queryParams.isEmpty
          ? ''
          : '?${queryParams.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&')}';

      final path = '/api/admin/analytics/top-coating-types/$queryString'.replaceAll('//', '/');
      final response = await _apiClient.get(path);

      return TopCoatingTypesModel.fromJson(response);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ParseException('Ошибка при получении топ типов покрытий: $e');
    }
  }
}

class _AnalyticsApiClient extends ApiClient {
  _AnalyticsApiClient(
    super.networkClient,
    String baseUrl,
    this._getAuthToken,
  ) : _baseUrl = baseUrl;

  final String _baseUrl;
  final String? Function() _getAuthToken;

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
