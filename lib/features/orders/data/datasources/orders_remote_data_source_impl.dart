import 'package:prime_top_front/core/network/api_client.dart';
import 'package:prime_top_front/core/network/exceptions.dart';
import 'package:prime_top_front/core/network/network_client.dart';
import 'package:prime_top_front/features/orders/data/datasources/orders_remote_data_source.dart';
import 'package:prime_top_front/features/orders/data/models/order_model.dart';
import 'package:prime_top_front/features/orders/data/models/orders_response_model.dart';

class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  OrdersRemoteDataSourceImpl({
    required NetworkClient networkClient,
    required String baseUrl,
    required String? Function() getAuthToken,
  })  : _apiClient = _OrdersApiClient(networkClient, baseUrl, getAuthToken);

  final _OrdersApiClient _apiClient;

  @override
  Future<OrdersResponseModel> getOrders({
    String? status,
    String? createdFrom,
    String? createdTo,
    int? limit,
    int? recent,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }
      if (createdFrom != null && createdFrom.isNotEmpty) {
        queryParams['created_from'] = createdFrom;
      }
      if (createdTo != null && createdTo.isNotEmpty) {
        queryParams['created_to'] = createdTo;
      }
      if (limit != null) {
        queryParams['limit'] = limit.toString();
      }
      if (recent != null) {
        queryParams['recent'] = recent.toString();
      }

      final queryString = queryParams.isEmpty
          ? ''
          : '?${queryParams.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&')}';

      final path = '/api/me/orders/$queryString'.replaceAll('//', '/');
      final response = await _apiClient.get(path);

      return OrdersResponseModel.fromJson(response);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ParseException('Ошибка при получении заказов: $e');
    }
  }

  @override
  Future<OrderModel> getOrderById(int orderId) async {
    try {
      final path = '/api/me/orders/$orderId/';
      final response = await _apiClient.get(path);

      return OrderModel.fromJson(response);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ParseException('Ошибка при получении заказа: $e');
    }
  }
}

class _OrdersApiClient extends ApiClient {
  _OrdersApiClient(
    NetworkClient networkClient,
    String baseUrl,
    this._getAuthToken,
  ) : _baseUrl = baseUrl,
       super(networkClient);

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

