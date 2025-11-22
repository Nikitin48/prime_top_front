import 'package:prime_top_front/features/orders/domain/entities/order.dart';
import 'package:prime_top_front/features/orders/domain/entities/orders_response.dart';

abstract class OrdersRepository {
  Future<OrdersResponse> getOrders({
    String? status,
    String? search,
    String? client,
    String? product,
    String? createdFrom,
    String? createdTo,
    String? shippedFrom,
    String? shippedTo,
    String? deliveredFrom,
    String? deliveredTo,
    String? sortBy,
    String? sortDirection,
    int? limit,
    int? offset,
    int? recent,
  });

  Future<OrdersResponse> getRecentOrders();

  Future<Order> getOrderById(int orderId);
}
