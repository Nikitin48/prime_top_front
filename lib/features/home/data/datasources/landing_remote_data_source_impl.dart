import 'package:prime_top_front/core/network/api_client.dart';
import 'package:prime_top_front/core/network/exceptions.dart';
import 'package:prime_top_front/core/network/network_client.dart';
import 'package:prime_top_front/features/home/data/datasources/landing_remote_data_source.dart';
import 'package:prime_top_front/features/home/data/models/landing_stats_model.dart';
import 'package:prime_top_front/features/products/data/models/product_model.dart';

class LandingRemoteDataSourceImpl implements LandingRemoteDataSource {
  LandingRemoteDataSourceImpl({
    required NetworkClient networkClient,
    required String baseUrl,
  }) : _apiClient = _LandingApiClient(networkClient, baseUrl);

  final _LandingApiClient _apiClient;

  @override
  Future<LandingStatsModel> getLandingStats() async {
    try {
      final response = await _apiClient.get('/api/landing/stats/');
      return LandingStatsModel.fromJson(response);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ParseException('Не удалось получить статистику: $e');
    }
  }

  @override
  Future<List<ProductModel>> getPopularProducts() async {
    try {
      final response = await _apiClient.get('/api/landing/popular-products/');
      final results =
          response['results'] as List<dynamic>? ??
          response as List<dynamic>? ??
          [];
      return results
          .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ParseException('Не удалось получить популярные продукты: $e');
    }
  }
}

class _LandingApiClient extends ApiClient {
  _LandingApiClient(NetworkClient client, this._baseUrl) : super(client);

  final String _baseUrl;

  @override
  Future<Map<String, dynamic>> get(String url, {Map<String, String>? headers}) {
    return super.get(_buildUrl(url), headers: headers);
  }

  @override
  void setAuthToken(String? token) {}

  String _buildUrl(String path) {
    final base = _baseUrl.endsWith('/')
        ? _baseUrl.substring(0, _baseUrl.length - 1)
        : _baseUrl;
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    return '$base$normalizedPath';
  }
}
