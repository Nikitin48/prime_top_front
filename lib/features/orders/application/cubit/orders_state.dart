import 'package:equatable/equatable.dart';
import 'package:prime_top_front/features/orders/domain/entities/orders_response.dart';

class OrdersState extends Equatable {
  const OrdersState({
    this.ordersResponse,
    this.isLoading = false,
    this.errorMessage,
    this.status,
    this.search,
    this.client,
    this.product,
    this.createdFrom,
    this.createdTo,
    this.shippedFrom,
    this.shippedTo,
    this.deliveredFrom,
    this.deliveredTo,
    this.sortBy,
    this.sortDirection,
    this.limit = 9999,
    this.offset = 0,
    this.tab = 'all',
  });

  final OrdersResponse? ordersResponse;
  final bool isLoading;
  final String? errorMessage;

  final String? status;
  final String? search;
  final String? client;
  final String? product;
  final String? createdFrom;
  final String? createdTo;
  final String? shippedFrom;
  final String? shippedTo;
  final String? deliveredFrom;
  final String? deliveredTo;
  final String? sortBy;
  final String? sortDirection;
  final int limit;
  final int offset;
  final String tab;

  OrdersState copyWith({
    OrdersResponse? ordersResponse,
    bool? isLoading,
    String? errorMessage,
    String? status,
    String? search,
    String? client,
    String? product,
    String? createdFrom,
    String? createdTo,
    String? shippedFrom,
    String? shippedTo,
    String? deliveredFrom,
    String? deliveredTo,
    String? sortBy,
    String? sortDirection,
    int? limit,
    int? offset,
    String? tab,
  }) {
    return OrdersState(
      ordersResponse: ordersResponse ?? this.ordersResponse,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      status: status ?? this.status,
      search: search ?? this.search,
      client: client ?? this.client,
      product: product ?? this.product,
      createdFrom: createdFrom ?? this.createdFrom,
      createdTo: createdTo ?? this.createdTo,
      shippedFrom: shippedFrom ?? this.shippedFrom,
      shippedTo: shippedTo ?? this.shippedTo,
      deliveredFrom: deliveredFrom ?? this.deliveredFrom,
      deliveredTo: deliveredTo ?? this.deliveredTo,
      sortBy: sortBy ?? this.sortBy,
      sortDirection: sortDirection ?? this.sortDirection,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
      tab: tab ?? this.tab,
    );
  }

  @override
  List<Object?> get props => [
        ordersResponse,
        isLoading,
        errorMessage,
        status,
        search,
        client,
        product,
        createdFrom,
        createdTo,
        shippedFrom,
        shippedTo,
        deliveredFrom,
        deliveredTo,
        sortBy,
        sortDirection,
        limit,
        offset,
        tab,
      ];
}
