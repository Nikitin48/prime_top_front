import 'package:equatable/equatable.dart';
import 'package:prime_top_front/features/orders/domain/entities/orders_response.dart';

class OrdersState extends Equatable {
  const OrdersState({
    this.ordersResponse,
    this.isLoading = false,
    this.errorMessage,
  });

  final OrdersResponse? ordersResponse;
  final bool isLoading;
  final String? errorMessage;

  OrdersState copyWith({
    OrdersResponse? ordersResponse,
    bool? isLoading,
    String? errorMessage,
  }) {
    return OrdersState(
      ordersResponse: ordersResponse ?? this.ordersResponse,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [ordersResponse, isLoading, errorMessage];
}

