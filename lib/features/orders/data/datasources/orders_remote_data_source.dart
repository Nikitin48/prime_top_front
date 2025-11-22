import 'package:prime_top_front/features/orders/data/models/order_model.dart';
import 'package:prime_top_front/features/orders/data/models/orders_response_model.dart';

abstract class OrdersRemoteDataSource {
  Future<OrdersResponseModel> getOrders({
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

  Future<OrderModel> getOrderById(int orderId);
}
