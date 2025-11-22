import 'package:prime_top_front/core/network/api_client.dart';
import 'package:prime_top_front/core/network/exceptions.dart';
import 'package:prime_top_front/core/network/network_client.dart';
import 'package:prime_top_front/features/admin/data/datasources/admin_remote_data_source.dart';
import 'package:prime_top_front/features/admin/data/models/admin_stock_model.dart';
import 'package:prime_top_front/features/admin/data/models/admin_stocks_response_model.dart';
import 'package:prime_top_front/features/orders/data/models/order_model.dart';
import 'package:prime_top_front/features/orders/data/models/orders_response_model.dart';

class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  AdminRemoteDataSourceImpl({
    required NetworkClient networkClient,
    required String baseUrl,
    required String? Function() getAuthToken,
  })  : _apiClient = _AdminApiClient(networkClient, baseUrl, getAuthToken);

  final _AdminApiClient _apiClient;

  @override
  Future<AdminStocksResponseModel> getAdminStocks({
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (limit != null) {
        queryParams['limit'] = limit.toString();
      }
      if (offset != null) {
        queryParams['offset'] = offset.toString();
      }

      final queryString = queryParams.isEmpty
          ? ''
          : '?${queryParams.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&')}';

      final path = '/api/admin/stocks/$queryString'.replaceAll('//', '/');
      final response = await _apiClient.get(path);

      return AdminStocksResponseModel.fromJson(response);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ParseException('Ошибка при получении остатков: $e');
    }
  }

  @override
  Future<AdminStockModel> updateStock({
    required int stockId,
    int? seriesId,
    int? clientId,
    double? quantity,
    bool? isReserved,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (seriesId != null) {
        body['series_id'] = seriesId;
      }
      if (clientId != null) {
        body['client_id'] = clientId;
      } else if (clientId == null && quantity != null) {
        body['client_id'] = null;
      }
      if (quantity != null) {
        body['quantity'] = quantity;
      }
      if (isReserved != null) {
        body['is_reserved'] = isReserved;
      }

      final path = '/api/admin/stocks/$stockId/';
      final response = await _apiClient.patch(path, body: body);

      return AdminStockModel.fromJson(response);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ParseException('Ошибка при обновлении остатка: $e');
    }
  }

  @override
  Future<AdminStockModel> createStock({
    required int seriesId,
    int? clientId,
    required double quantity,
    bool? isReserved,
  }) async {
    try {
      final body = <String, dynamic>{
        'series_id': seriesId,
        'quantity': quantity,
      };
      if (clientId != null) {
        body['client_id'] = clientId;
      }
      if (isReserved != null) {
        body['is_reserved'] = isReserved;
      } else {
        body['is_reserved'] = false;
      }

      final path = '/api/admin/stocks/';
      final response = await _apiClient.post(path, body: body);

      return AdminStockModel.fromJson(response);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ParseException('Ошибка при создании остатка: $e');
    }
  }

  @override
  Future<void> deleteStock(int stockId) async {
    try {
      final path = '/api/admin/stocks/$stockId/delete/';
      await _apiClient.delete(path);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ParseException('Ошибка при удалении остатка: $e');
    }
  }

  @override
  Future<OrdersResponseModel> getAdminOrders({
    int? clientId,
    String? status,
    String? createdFrom,
    String? createdTo,
    String? shippedFrom,
    String? shippedTo,
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (clientId != null) {
        queryParams['client_id'] = clientId.toString();
      }
      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }
      if (createdFrom != null && createdFrom.isNotEmpty) {
        queryParams['created_from'] = createdFrom;
      }
      if (createdTo != null && createdTo.isNotEmpty) {
        queryParams['created_to'] = createdTo;
      }
      if (shippedFrom != null && shippedFrom.isNotEmpty) {
        queryParams['shipped_from'] = shippedFrom;
      }
      if (shippedTo != null && shippedTo.isNotEmpty) {
        queryParams['shipped_to'] = shippedTo;
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

      final path = '/api/admin/orders/$queryString'.replaceAll('//', '/');
      final response = await _apiClient.get(path);

      return OrdersResponseModel.fromAdminJson(response);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ParseException('Ошибка при получении заказов: $e');
    }
  }

  @override
  Future<OrderModel> getAdminOrderById(int orderId) async {
    try {
      final path = '/api/admin/orders/$orderId/';
      final response = await _apiClient.get(path);

      return OrderModel.fromJson(response);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ParseException('Ошибка при получении заказа: $e');
    }
  }

  @override
  Future<OrderModel> updateAdminOrder({
    required int orderId,
    String? status,
    String? shippedAt,
    String? deliveredAt,
    String? cancelReason,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (status != null) {
        body['status'] = status;
      }
      if (shippedAt != null) {
        body['shipped_at'] = shippedAt;
      }
      if (deliveredAt != null) {
        body['delivered_at'] = deliveredAt;
      }
      if (cancelReason != null) {
        body['cancel_reason'] = cancelReason;
      }

      final path = '/api/admin/orders/$orderId/';
      final response = await _apiClient.patch(path, body: body);

      return OrderModel.fromJson(response);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ParseException('Ошибка при обновлении заказа: $e');
    }
  }
}

class _AdminApiClient extends ApiClient {
  _AdminApiClient(
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
