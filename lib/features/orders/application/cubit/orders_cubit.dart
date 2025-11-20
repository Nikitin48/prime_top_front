import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_top_front/features/orders/application/cubit/orders_state.dart';
import 'package:prime_top_front/features/orders/domain/repositories/orders_repository.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit(this._repository) : super(const OrdersState());

  final OrdersRepository _repository;

  Future<void> loadOrders({
    String? status,
    String? createdFrom,
    String? createdTo,
    int? limit,
    int? recent,
  }) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final ordersResponse = await _repository.getOrders(
        status: status,
        createdFrom: createdFrom,
        createdTo: createdTo,
        limit: limit,
        recent: recent,
      );
      emit(state.copyWith(
        ordersResponse: ordersResponse,
        isLoading: false,
        errorMessage: null,
      ));
    } on Exception catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Ошибка загрузки заказов',
      ));
    }
  }

  void clearOrders() {
    emit(const OrdersState());
  }
}

