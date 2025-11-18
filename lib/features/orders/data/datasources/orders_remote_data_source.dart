import 'package:prime_top_front/features/orders/data/models/order_model.dart';
import 'package:prime_top_front/features/orders/data/models/orders_response_model.dart';

abstract class OrdersRemoteDataSource {
  Future<OrdersResponseModel> getOrders({
    String? status,
    String? createdFrom,
    String? createdTo,
    int? limit,
  });

  Future<OrderModel> getOrderById(int orderId);
}

