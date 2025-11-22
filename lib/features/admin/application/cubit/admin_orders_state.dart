import 'package:equatable/equatable.dart';
import 'package:prime_top_front/features/orders/domain/entities/order.dart';
import 'package:prime_top_front/features/orders/domain/entities/orders_response.dart';

class AdminOrdersState extends Equatable {
  const AdminOrdersState({
    this.ordersResponse,
    this.isLoading = false,
    this.errorMessage,
    this.status,
    this.clientId,
    this.createdFrom,
    this.createdTo,
    this.shippedFrom,
    this.shippedTo,
    this.limit = 20,
    this.offset = 0,
    this.searchQuery,
    this.searchedOrder,
    this.isSearching = false,
  });

  final OrdersResponse? ordersResponse;
  final bool isLoading;
  final String? errorMessage;

  final String? status;
  final int? clientId;
  final String? createdFrom;
  final String? createdTo;
  final String? shippedFrom;
  final String? shippedTo;
  final int limit;
  final int offset;

  final String? searchQuery;
  final Order? searchedOrder;
  final bool isSearching;

  AdminOrdersState copyWith({
    OrdersResponse? ordersResponse,
    bool? isLoading,
    String? errorMessage,
    String? status,
    int? clientId,
    String? createdFrom,
    String? createdTo,
    String? shippedFrom,
    String? shippedTo,
    int? limit,
    int? offset,
    String? searchQuery,
    Order? searchedOrder,
    bool? isSearching,
  }) {
    return AdminOrdersState(
      ordersResponse: ordersResponse ?? this.ordersResponse,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      status: status ?? this.status,
      clientId: clientId ?? this.clientId,
      createdFrom: createdFrom ?? this.createdFrom,
      createdTo: createdTo ?? this.createdTo,
      shippedFrom: shippedFrom ?? this.shippedFrom,
      shippedTo: shippedTo ?? this.shippedTo,
      limit: limit ?? this.limit,
      offset: offset ?? this.offset,
      searchQuery: searchQuery,
      searchedOrder: searchedOrder,
      isSearching: isSearching ?? this.isSearching,
    );
  }

  @override
  List<Object?> get props => [
        ordersResponse,
        isLoading,
        errorMessage,
        status,
        clientId,
        createdFrom,
        createdTo,
        shippedFrom,
        shippedTo,
        limit,
        offset,
        searchQuery,
        searchedOrder,
        isSearching,
      ];
}
