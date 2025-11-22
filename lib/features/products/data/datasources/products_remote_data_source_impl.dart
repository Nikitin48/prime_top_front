import 'package:prime_top_front/core/network/api_client.dart';
import 'package:prime_top_front/core/network/exceptions.dart';
import 'package:prime_top_front/core/network/network_client.dart';
import 'package:prime_top_front/features/products/data/datasources/products_remote_data_source.dart';
import 'package:prime_top_front/features/products/data/models/product_detail_model.dart';
import 'package:prime_top_front/features/products/data/models/product_model.dart';

class ProductsRemoteDataSourceImpl implements ProductsRemoteDataSource {
  ProductsRemoteDataSourceImpl({
    required NetworkClient networkClient,
    required String baseUrl,
  }) : _apiClient = _ProductsApiClient(networkClient, baseUrl);

  final _ProductsApiClient _apiClient;

  @override
  Future<ProductsDataResponse> getProducts({
    int? coatingTypeId,
    String? name,
    String? nomenclature,
    String? color,
    int? minPrice,
    int? maxPrice,
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (coatingTypeId != null) {
        queryParams['coating_type_id'] = coatingTypeId.toString();
      }
      if (name != null && name.isNotEmpty) {
        queryParams['name'] = name;
      }
      if (nomenclature != null && nomenclature.isNotEmpty) {
        queryParams['nomenclature'] = nomenclature;
      }
      if (color != null && color.isNotEmpty) {
        queryParams['color'] = color;
      }
      if (minPrice != null) {
        queryParams['min_price'] = minPrice.toString();
      }
      if (maxPrice != null) {
        queryParams['max_price'] = maxPrice.toString();
      }
      if (limit != null) {
        queryParams['limit'] = limit.toString();
      }
      if (offset != null) {
        queryParams['offset'] = offset.toString();
      }

      final queryString = queryParams.isEmpty
          ? ''
          : '?${queryParams.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&')}';

      final path = '/api/products/$queryString'.replaceAll('//', '/');
      final response = await _apiClient.get(path);

      final count = response['count'] as int?;
      if (count == null) {
        throw ParseException('Отсутствует поле count в ответе сервера');
      }

      final results = response['results'] as List<dynamic>?;
      if (results == null) {
        throw ParseException('Отсутствует поле results в ответе сервера');
      }

      final products = results
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return ProductsDataResponse(
        products: products,
        count: count,
      );
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ParseException('Ошибка при получении продуктов: $e');
    }
  }

  @override
  Future<ProductsDataResponse> searchProducts({
    required String query,
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, String>{
        'q': query,
      };
      if (limit != null) {
        queryParams['limit'] = limit.toString();
      }
      if (offset != null) {
        queryParams['offset'] = offset.toString();
      }

      final queryString = '?${queryParams.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&')}';

      final path = '/api/products/search/$queryString'.replaceAll('//', '/');
      final response = await _apiClient.get(path);

      final count = response['count'] as int?;
      if (count == null) {
        throw ParseException('Отсутствует поле count в ответе сервера');
      }

      final results = response['results'] as List<dynamic>?;
      if (results == null) {
        throw ParseException('Отсутствует поле results в ответе сервера');
      }

      final products = results
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return ProductsDataResponse(
        products: products,
        count: count,
      );
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ParseException('Ошибка при поиске продуктов: $e');
    }
  }

  @override
  Future<ProductDetailModel> getProductDetail(int productId) async {
    try {
      final path = '/api/products/$productId/';
      final response = await _apiClient.get(path);

      return ProductDetailModel.fromJson(response);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ParseException('Ошибка при получении детальной информации о продукте: $e');
    }
  }
}

class _ProductsApiClient extends ApiClient {
  _ProductsApiClient(NetworkClient networkClient, String baseUrl)
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
