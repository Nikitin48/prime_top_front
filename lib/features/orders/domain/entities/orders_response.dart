import 'package:equatable/equatable.dart';
import 'package:prime_top_front/features/auth/domain/entities/client.dart';
import 'package:prime_top_front/features/orders/domain/entities/order.dart';
import 'package:prime_top_front/features/orders/domain/entities/orders_summary.dart';

class OrdersResponse extends Equatable {
  const OrdersResponse({
    required this.client,
    required this.summary,
    required this.totalCount,
    required this.count,
    required this.orders,
  });

  final Client client;
  final List<OrdersSummary> summary;
  final int totalCount;
  final int count;
  final List<Order> orders;

  @override
  List<Object?> get props => [client, summary, totalCount, count, orders];
}
