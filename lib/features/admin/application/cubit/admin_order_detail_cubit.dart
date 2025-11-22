import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_top_front/features/admin/domain/repositories/admin_repository.dart';
import 'package:prime_top_front/features/orders/application/cubit/order_detail_state.dart';

class AdminOrderDetailCubit extends Cubit<OrderDetailState> {
  AdminOrderDetailCubit(this._repository) : super(const OrderDetailState());

  final AdminRepository _repository;

  Future<void> loadOrder(int orderId) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final order = await _repository.getAdminOrderById(orderId);
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

  Future<void> updateOrder({
    required int orderId,
    String? status,
    String? shippedAt,
    String? deliveredAt,
    String? cancelReason,
  }) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final order = await _repository.updateAdminOrder(
        orderId: orderId,
        status: status,
        shippedAt: shippedAt,
        deliveredAt: deliveredAt,
        cancelReason: cancelReason,
      );
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
        errorMessage: 'Ошибка обновления заказа',
      ));
    }
  }
}
