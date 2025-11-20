import 'package:prime_top_front/core/network/api_client.dart';
import 'package:prime_top_front/core/network/exceptions.dart';
import 'package:prime_top_front/core/network/network_client.dart';
import 'package:prime_top_front/features/home/data/datasources/top_products_remote_data_source.dart';
import 'package:prime_top_front/features/home/data/models/top_products_response_model.dart';

class TopProductsRemoteDataSourceImpl implements TopProductsRemoteDataSource {
  TopProductsRemoteDataSourceImpl({
    required NetworkClient networkClient,
    required String baseUrl,
  }) : _apiClient = _TopProductsApiClient(networkClient, baseUrl);

  final _TopProductsApiClient _apiClient;

  @override
  Future<TopProductsResponseModel> getTopProducts() async {
    try {
      final path = '/api/products/top/';
      final response = await _apiClient.get(path);

      return TopProductsResponseModel.fromJson(response);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ParseException('Ошибка при получении популярных товаров: $e');
    }
  }
}

class _TopProductsApiClient extends ApiClient {
  _TopProductsApiClient(NetworkClient networkClient, String baseUrl)
      : _baseUrl = baseUrl,
        super(networkClient);

  final String _baseUrl;

  @override
  Future<Map<String, dynamic>> get(
    String url, {
    Map<String, String>? headers,
  }) {
    return super.get(_buildUrl(url), headers: headers);
  }

  @override
  void setAuthToken(String? token) {}

  String _buildUrl(String path) {
    final base = _baseUrl.endsWith('/') ? _baseUrl.substring(0, _baseUrl.length - 1) : _baseUrl;
    final url = path.startsWith('/') ? path : '/$path';
    return '$base$url';
  }
}

