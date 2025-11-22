import 'package:prime_top_front/features/orders/domain/entities/orders_summary.dart';

class OrdersSummaryModel extends OrdersSummary {
  const OrdersSummaryModel({
    required super.status,
    required super.ordersCount,
    required super.seriesCount,
    required super.totalQuantity,
  });

  factory OrdersSummaryModel.fromJson(Map<String, dynamic> json) {
    return OrdersSummaryModel(
      status: json['status'] as String,
      ordersCount: json['orders_count'] as int,
      seriesCount: json['series_count'] as int,
      totalQuantity: (json['total_quantity'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'orders_count': ordersCount,
      'series_count': seriesCount,
      'total_quantity': totalQuantity,
    };
  }

  OrdersSummary toEntity() {
    return OrdersSummary(
      status: status,
      ordersCount: ordersCount,
      seriesCount: seriesCount,
      totalQuantity: totalQuantity,
    );
  }
}
