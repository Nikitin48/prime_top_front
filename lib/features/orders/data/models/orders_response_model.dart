import 'package:prime_top_front/features/auth/data/models/client_model.dart';
import 'package:prime_top_front/features/orders/data/models/order_model.dart';
import 'package:prime_top_front/features/orders/data/models/orders_summary_model.dart';
import 'package:prime_top_front/features/orders/domain/entities/orders_response.dart';

class OrdersResponseModel extends OrdersResponse {
  const OrdersResponseModel({
    required super.client,
    required super.summary,
    required super.totalCount,
    required super.count,
    required super.orders,
  });

  factory OrdersResponseModel.fromJson(Map<String, dynamic> json) {
    return OrdersResponseModel(
      client: ClientModel.fromJson(
        json['client'] as Map<String, dynamic>,
      ),
      summary: (json['summary'] as List<dynamic>)
          .map((item) => OrdersSummaryModel.fromJson(
                item as Map<String, dynamic>,
              ))
          .toList(),
      totalCount: json['total_count'] as int,
      count: json['count'] as int,
      orders: (json['orders'] as List<dynamic>)
          .map((item) => OrderModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  factory OrdersResponseModel.fromAdminJson(Map<String, dynamic> json) {
    final count = json['count'] is int ? json['count'] as int : 0;
    
    final orders = <OrderModel>[];
    if (json['results'] is List) {
      final resultsList = json['results'] as List;
      orders.addAll(
        resultsList
            .map((item) {
              try {
                if (item is Map<String, dynamic>) {
                  return OrderModel.fromAdminListJson(item);
                }
              } catch (e) {
              }
              return null;
            })
            .whereType<OrderModel>(),
      );
    }

    return OrdersResponseModel(
      client: ClientModel.fromJson({
        'id': 0,
        'name': '',
        'email': '',
      }),
      summary: [],
      totalCount: count,
      count: orders.length,
      orders: orders,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'client': (client as ClientModel).toJson(),
      'summary': summary
          .map((item) => (item as OrdersSummaryModel).toJson())
          .toList(),
      'total_count': totalCount,
      'count': count,
      'orders': orders
          .map((item) => (item as OrderModel).toJson())
          .toList(),
    };
  }

  OrdersResponse toEntity() {
    return OrdersResponse(
      client: client,
      summary: summary.map((item) => (item as OrdersSummaryModel).toEntity()).toList(),
      totalCount: totalCount,
      count: count,
      orders: orders.map((item) => (item as OrderModel).toEntity()).toList(),
    );
  }
}
