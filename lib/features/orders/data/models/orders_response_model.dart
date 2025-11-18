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

