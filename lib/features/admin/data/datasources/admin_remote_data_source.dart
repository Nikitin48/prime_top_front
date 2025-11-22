import 'package:prime_top_front/features/admin/data/models/admin_stock_model.dart';
import 'package:prime_top_front/features/admin/data/models/admin_stocks_response_model.dart';
import 'package:prime_top_front/features/orders/data/models/order_model.dart';
import 'package:prime_top_front/features/orders/data/models/orders_response_model.dart';

abstract class AdminRemoteDataSource {
  Future<AdminStocksResponseModel> getAdminStocks({
    int? limit,
    int? offset,
  });

  Future<AdminStockModel> updateStock({
    required int stockId,
    int? seriesId,
    int? clientId,
    double? quantity,
    bool? isReserved,
  });

  Future<AdminStockModel> createStock({
    required int seriesId,
    int? clientId,
    required double quantity,
    bool? isReserved,
  });

  Future<void> deleteStock(int stockId);

  Future<OrdersResponseModel> getAdminOrders({
    int? clientId,
    String? status,
    String? createdFrom,
    String? createdTo,
    String? shippedFrom,
    String? shippedTo,
    int? limit,
    int? offset,
  });

  Future<OrderModel> getAdminOrderById(int orderId);

  Future<OrderModel> updateAdminOrder({
    required int orderId,
    String? status,
    String? shippedAt,
    String? deliveredAt,
    String? cancelReason,
  });
}
