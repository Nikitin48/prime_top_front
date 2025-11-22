import 'package:prime_top_front/core/network/api_client.dart';
import 'package:prime_top_front/core/network/exceptions.dart';
import 'package:prime_top_front/core/network/network_client.dart';
import 'package:prime_top_front/features/cart/data/datasources/cart_remote_data_source.dart';
import 'package:prime_top_front/features/cart/data/models/cart_item_model.dart';
import 'package:prime_top_front/features/cart/data/models/cart_model.dart';
import 'package:prime_top_front/features/orders/data/models/order_model.dart';

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  CartRemoteDataSourceImpl({
    required NetworkClient networkClient,
    required String baseUrl,
    required String? Function() getAuthToken,
  })  : _apiClient = _CartApiClient(networkClient, baseUrl, getAuthToken);

  final _CartApiClient _apiClient;

  @override
  Future<CartModel> getCart() async {
    try {
      final path = '/api/me/cart/';
      final response = await _apiClient.get(path);
      return CartModel.fromJson(response);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ParseException('Ошибка при получении корзины: $e');
    }
  }

  @override
  Future<CartItemModel> addItemToCart({
    required int productId,
    int? seriesId,
    int quantity = 1,
  }) async {
    try {
      final path = '/api/me/cart/items/';
      final body = <String, dynamic>{
        'product_id': productId,
        'quantity': quantity,
      };
      if (seriesId != null) {
        body['series_id'] = seriesId;
      }
      final response = await _apiClient.post(path, body: body);
      return CartItemModel.fromJson(response);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ParseException('Ошибка при добавлении товара в корзину: $e');
    }
  }

  @override
  Future<CartItemModel> updateCartItemQuantity({
    required int cartItemId,
    required int quantity,
  }) async {
    try {
      final path = '/api/me/cart/items/$cartItemId/';
      final body = {
        'quantity': quantity,
      };
      final response = await _apiClient.patch(path, body: body);
      return CartItemModel.fromJson(response);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ParseException('Ошибка при обновлении количества товара: $e');
    }
  }

  @override
  Future<void> removeCartItem(int cartItemId) async {
    try {
      final path = '/api/me/cart/items/$cartItemId/';
      await _apiClient.delete(path);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ParseException('Ошибка при удалении товара из корзины: $e');
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      final path = '/api/me/cart/clear/';
      await _apiClient.delete(path);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ParseException('Ошибка при очистке корзины: $e');
    }
  }

  @override
  Future<OrderModel> checkout({
    String? status,
    String? statusNote,
    String? createdAt,
    String? shippedAt,
    String? deliveredAt,
    String? cancelReason,
  }) async {
    try {
      final path = '/api/me/cart/checkout/';
      final body = <String, dynamic>{};
      if (status != null) body['status'] = status;
      if (statusNote != null) body['status_note'] = statusNote;
      if (createdAt != null) body['created_at'] = createdAt;
      if (shippedAt != null) body['shipped_at'] = shippedAt;
      if (deliveredAt != null) body['delivered_at'] = deliveredAt;
      if (cancelReason != null) body['cancel_reason'] = cancelReason;

      final response = await _apiClient.post(path, body: body);
      return OrderModel.fromJson(response);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw ParseException('Ошибка при оформлении заказа: $e');
    }
  }
}

class _CartApiClient extends ApiClient {
  _CartApiClient(
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
