import 'package:equatable/equatable.dart';
import 'package:prime_top_front/features/orders/domain/entities/order.dart';

class OrderDetailState extends Equatable {
  const OrderDetailState({
    this.order,
    this.isLoading = false,
    this.errorMessage,
  });

  final Order? order;
  final bool isLoading;
  final String? errorMessage;

  OrderDetailState copyWith({
    Order? order,
    bool? isLoading,
    String? errorMessage,
  }) {
    return OrderDetailState(
      order: order ?? this.order,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [order, isLoading, errorMessage];
}
