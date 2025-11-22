import 'package:equatable/equatable.dart';
import 'package:prime_top_front/features/auth/domain/entities/client.dart';
import 'package:prime_top_front/features/orders/domain/entities/order_item.dart';
import 'package:prime_top_front/features/orders/domain/entities/order_status_history.dart';

class Order extends Equatable {
  const Order({
    required this.id,
    required this.client,
    required this.status,
    required this.createdAt,
    required this.items,
    required this.totalQuantity,
    required this.statusHistory,
    this.shippedAt,
    this.deliveredAt,
    this.cancelReason,
  });

  final int id;
  final Client client;
  final String status;
  final DateTime createdAt;
  final DateTime? shippedAt;
  final DateTime? deliveredAt;
  final String? cancelReason;
  final List<OrderItem> items;
  final double totalQuantity;
  final List<OrderStatusHistory> statusHistory;

  @override
  List<Object?> get props => [
        id,
        client,
        status,
        createdAt,
        shippedAt,
        deliveredAt,
        cancelReason,
        items,
        totalQuantity,
        statusHistory,
      ];
}
