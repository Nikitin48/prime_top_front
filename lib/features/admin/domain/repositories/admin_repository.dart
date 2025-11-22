import 'package:prime_top_front/features/admin/domain/entities/admin_stock.dart';
import 'package:prime_top_front/features/admin/domain/entities/admin_stocks_response.dart';
import 'package:prime_top_front/features/orders/domain/entities/order.dart';
import 'package:prime_top_front/features/orders/domain/entities/orders_response.dart';

abstract class AdminRepository {
  Future<AdminStocksResponse> getAdminStocks({
    int? limit,
    int? offset,
  });

  Future<AdminStock> updateStock({
    required int stockId,
    int? seriesId,
    int? clientId,
    double? quantity,
    bool? isReserved,
  });

  Future<AdminStock> createStock({
    required int seriesId,
    int? clientId,
    required double quantity,
    bool? isReserved,
  });

  Future<void> deleteStock(int stockId);

  Future<OrdersResponse> getAdminOrders({
    int? clientId,
    String? status,
    String? createdFrom,
    String? createdTo,
    String? shippedFrom,
    String? shippedTo,
    int? limit,
    int? offset,
  });

  Future<Order> getAdminOrderById(int orderId);

  Future<Order> updateAdminOrder({
    required int orderId,
    String? status,
    String? shippedAt,
    String? deliveredAt,
    String? cancelReason,
  });
}
