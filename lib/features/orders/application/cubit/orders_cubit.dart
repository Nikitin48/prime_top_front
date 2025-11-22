import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_top_front/features/orders/application/cubit/orders_state.dart';
import 'package:prime_top_front/features/orders/domain/repositories/orders_repository.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit(this._repository) : super(const OrdersState());

  final OrdersRepository _repository;
  int _requestToken = 0;

  Future<void> loadOrders({
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
    String? tab,
  }) async {
    final effectiveStatus = status ?? (tab != null ? null : state.status);

    _requestToken++;
    final currentToken = _requestToken;

    final nextState = state.copyWith(
      status: effectiveStatus,
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
      tab: tab ?? state.tab,
      errorMessage: null,
      isLoading: true,
    );

    emit(nextState);

    try {
      final ordersResponse = await _repository.getOrders(
        status: nextState.status,
        search: nextState.search,
        client: nextState.client,
        product: nextState.product,
        createdFrom: nextState.createdFrom,
        createdTo: nextState.createdTo,
        shippedFrom: nextState.shippedFrom,
        shippedTo: nextState.shippedTo,
        deliveredFrom: nextState.deliveredFrom,
        deliveredTo: nextState.deliveredTo,
        sortBy: nextState.sortBy,
        sortDirection: nextState.sortDirection,
        limit: nextState.limit,
        offset: nextState.offset,
        recent: recent,
      );

      if (currentToken != _requestToken) {
        return;
      }

      emit(
        nextState.copyWith(
          ordersResponse: ordersResponse,
          isLoading: false,
          errorMessage: null,
        ),
      );
    } on Exception catch (e) {
      if (currentToken != _requestToken) {
        return;
      }

      emit(
        nextState.copyWith(
          isLoading: false,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    } catch (_) {
      if (currentToken != _requestToken) {
        return;
      }

      emit(
        nextState.copyWith(
          isLoading: false,
          errorMessage: 'Что-то пошло не так, попробуйте позже',
        ),
      );
    }
  }

  void clearOrders() {
    emit(const OrdersState());
  }
}
