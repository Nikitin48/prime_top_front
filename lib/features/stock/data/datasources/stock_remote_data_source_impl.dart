import 'package:prime_top_front/core/network/api_client.dart';
import 'package:prime_top_front/core/network/exceptions.dart';
import 'package:prime_top_front/core/network/network_client.dart';
import 'package:prime_top_front/features/stock/data/datasources/stock_remote_data_source.dart';
import 'package:prime_top_front/features/stock/data/models/available_stocks_response_model.dart';

class StockRemoteDataSourceImpl implements StockRemoteDataSource {
  StockRemoteDataSourceImpl({
    required NetworkClient networkClient,
    required String baseUrl,
  }) : _apiClient = _StockApiClient(networkClient, baseUrl);

  final _StockApiClient _apiClient;

  @override
  Future<AvailableStocksResponseModel> getAvailableStocks({
    int? clientId,
    String? color,
    String? coatingType,
    String? series,
    double? minQuantity,
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (clientId != null) {
        queryParams['client_id'] = clientId.toString();
      }
      if (color != null && color.isNotEmpty) {
        queryParams['color'] = color;
      }
      if (coatingType != null && coatingType.isNotEmpty) {
        queryParams['coating_type'] = coatingType;
      }
      if (series != null && series.isNotEmpty) {
        queryParams['series'] = series;
      }
      if (minQuantity != null) {
        queryParams['min_quantity'] = minQuantity.toString();
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

      final path = '/api/stocks/available/$queryString'.replaceAll('//', '/');
      final response = await _apiClient.get(path);

      return AvailableStocksResponseModel.fromJson(response);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ParseException('Ошибка при получении остатков: $e');
    }
  }
}

class _StockApiClient extends ApiClient {
  _StockApiClient(NetworkClient networkClient, String baseUrl)
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
