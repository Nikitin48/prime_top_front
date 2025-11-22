import 'package:equatable/equatable.dart';

class OrdersSummary extends Equatable {
  const OrdersSummary({
    required this.status,
    required this.ordersCount,
    required this.seriesCount,
    required this.totalQuantity,
  });

  final String status;
  final int ordersCount;
  final int seriesCount;
  final double totalQuantity;

  @override
  List<Object?> get props => [status, ordersCount, seriesCount, totalQuantity];
}
