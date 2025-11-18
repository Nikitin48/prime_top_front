import 'package:prime_top_front/core/network/exceptions.dart';
import 'package:prime_top_front/features/orders/data/datasources/orders_remote_data_source.dart';
import 'package:prime_top_front/features/orders/domain/entities/order.dart';
import 'package:prime_top_front/features/orders/domain/entities/orders_response.dart';
import 'package:prime_top_front/features/orders/domain/repositories/orders_repository.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  OrdersRepositoryImpl(this._remoteDataSource);

  final OrdersRemoteDataSource _remoteDataSource;

  @override
  Future<OrdersResponse> getOrders({
    String? status,
    String? createdFrom,
    String? createdTo,
    int? limit,
  }) async {
    try {
      final dataResponse = await _remoteDataSource.getOrders(
        status: status,
        createdFrom: createdFrom,
        createdTo: createdTo,
        limit: limit,
      );
      return dataResponse.toEntity();
    } on NetworkException catch (e) {
      throw Exception('Ошибка сети: ${e.message}');
    } catch (e) {
      throw Exception('Неожиданная ошибка при получении заказов: $e');
    }
  }

  @override
  Future<Order> getOrderById(int orderId) async {
    try {
      final dataResponse = await _remoteDataSource.getOrderById(orderId);
      return dataResponse.toEntity();
    } on NetworkException catch (e) {
      throw Exception('Ошибка сети: ${e.message}');
    } catch (e) {
      throw Exception('Неожиданная ошибка при получении заказа: $e');
    }
  }
}

