import 'package:prime_top_front/features/orders/data/datasources/orders_remote_data_source.dart';
import 'package:prime_top_front/features/orders/domain/entities/order.dart';
import 'package:prime_top_front/features/orders/domain/entities/orders_response.dart';
import 'package:prime_top_front/features/orders/domain/repositories/orders_repository.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  OrdersRepositoryImpl(this._remoteDataSource);

  final OrdersRemoteDataSource _remoteDataSource;

  @override
  Future<OrdersResponse> getOrders({
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
    int? recent,
  }) async {
    final dataResponse = await _remoteDataSource.getOrders(
      status: status,
      search: search,
      client: client,
      product: product,
      createdFrom: createdFrom,
      createdTo: createdTo,
      shippedFrom: shippedFrom,
      shippedTo: shippedTo,
      deliveredFrom: deliveredFrom,
      deliveredTo: deliveredTo,
      sortBy: sortBy,
      sortDirection: sortDirection,
      limit: limit,
      offset: offset,
      recent: recent,
    );

    return dataResponse.toEntity();
  }

  @override
  Future<OrdersResponse> getRecentOrders() async {
    final dataResponse = await _remoteDataSource.getOrders(recent: 5);
    return dataResponse.toEntity();
  }

  @override
  Future<Order> getOrderById(int orderId) async {
    final model = await _remoteDataSource.getOrderById(orderId);
    return model.toEntity();
  }
}
