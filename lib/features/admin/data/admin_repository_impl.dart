import 'package:prime_top_front/core/network/exceptions.dart';
import 'package:prime_top_front/features/admin/data/datasources/admin_remote_data_source.dart';
import 'package:prime_top_front/features/admin/domain/entities/admin_stock.dart';
import 'package:prime_top_front/features/admin/domain/entities/admin_stocks_response.dart';
import 'package:prime_top_front/features/admin/domain/repositories/admin_repository.dart';
import 'package:prime_top_front/features/orders/domain/entities/order.dart';
import 'package:prime_top_front/features/orders/domain/entities/orders_response.dart';

class AdminRepositoryImpl implements AdminRepository {
  AdminRepositoryImpl(this._remoteDataSource);

  final AdminRemoteDataSource _remoteDataSource;

  @override
  Future<AdminStocksResponse> getAdminStocks({
    int? limit,
    int? offset,
  }) async {
    try {
      final response = await _remoteDataSource.getAdminStocks(
        limit: limit,
        offset: offset,
      );
      return response.toEntity();
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw Exception('Ошибка при получении остатков: $e');
    }
  }

  @override
  Future<AdminStock> updateStock({
    required int stockId,
    int? seriesId,
    int? clientId,
    double? quantity,
    bool? isReserved,
  }) async {
    try {
      final stock = await _remoteDataSource.updateStock(
        stockId: stockId,
        seriesId: seriesId,
        clientId: clientId,
        quantity: quantity,
        isReserved: isReserved,
      );
      return stock.toEntity();
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw Exception('Ошибка при обновлении остатка: $e');
    }
  }

  @override
  Future<AdminStock> createStock({
    required int seriesId,
    int? clientId,
    required double quantity,
    bool? isReserved,
  }) async {
    try {
      final stock = await _remoteDataSource.createStock(
        seriesId: seriesId,
        clientId: clientId,
        quantity: quantity,
        isReserved: isReserved,
      );
      return stock.toEntity();
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw Exception('Ошибка при создании остатка: $e');
    }
  }

  @override
  Future<void> deleteStock(int stockId) async {
    try {
      await _remoteDataSource.deleteStock(stockId);
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw Exception('Ошибка при удалении остатка: $e');
    }
  }

  @override
  Future<OrdersResponse> getAdminOrders({
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
      final response = await _remoteDataSource.getAdminOrders(
        clientId: clientId,
        status: status,
        createdFrom: createdFrom,
        createdTo: createdTo,
        shippedFrom: shippedFrom,
        shippedTo: shippedTo,
        limit: limit,
        offset: offset,
      );
      return response.toEntity();
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw Exception('Ошибка при получении заказов: $e');
    }
  }

  @override
  Future<Order> getAdminOrderById(int orderId) async {
    try {
      final orderModel = await _remoteDataSource.getAdminOrderById(orderId);
      return orderModel;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw Exception('Ошибка при получении заказа: $e');
    }
  }

  @override
  Future<Order> updateAdminOrder({
    required int orderId,
    String? status,
    String? shippedAt,
    String? deliveredAt,
    String? cancelReason,
  }) async {
    try {
      final orderModel = await _remoteDataSource.updateAdminOrder(
        orderId: orderId,
        status: status,
        shippedAt: shippedAt,
        deliveredAt: deliveredAt,
        cancelReason: cancelReason,
      );
      return orderModel;
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw Exception('Ошибка при обновлении заказа: $e');
    }
  }
}
