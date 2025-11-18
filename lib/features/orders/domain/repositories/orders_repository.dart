import 'package:prime_top_front/features/orders/domain/entities/order.dart';
import 'package:prime_top_front/features/orders/domain/entities/orders_response.dart';

abstract class OrdersRepository {
  Future<OrdersResponse> getOrders({
    String? status,
    String? createdFrom,
    String? createdTo,
    int? limit,
  });

  Future<Order> getOrderById(int orderId);
}

