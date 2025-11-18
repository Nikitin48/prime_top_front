import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_top_front/features/orders/application/cubit/order_detail_state.dart';
import 'package:prime_top_front/features/orders/domain/repositories/orders_repository.dart';

class OrderDetailCubit extends Cubit<OrderDetailState> {
  OrderDetailCubit(this._repository) : super(const OrderDetailState());

  final OrdersRepository _repository;

  Future<void> loadOrder(int orderId) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final order = await _repository.getOrderById(orderId);
      emit(state.copyWith(
        order: order,
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
        errorMessage: 'Ошибка загрузки заказа',
      ));
    }
  }

  void clearOrder() {
    emit(const OrderDetailState());
  }
}
