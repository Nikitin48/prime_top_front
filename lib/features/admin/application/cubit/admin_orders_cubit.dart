import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_top_front/features/admin/application/cubit/admin_orders_state.dart';
import 'package:prime_top_front/features/admin/domain/repositories/admin_repository.dart';

class AdminOrdersCubit extends Cubit<AdminOrdersState> {
  AdminOrdersCubit(this._repository) : super(const AdminOrdersState());

  final AdminRepository _repository;
  int _requestToken = 0;

  Future<void> loadOrders({
    int? clientId,
    String? status,
    String? createdFrom,
    String? createdTo,
    String? shippedFrom,
    String? shippedTo,
    int? limit,
    int? offset,
  }) async {
    final effectiveStatus = status ?? state.status;

    _requestToken++;
    final currentToken = _requestToken;

    final nextState = state.copyWith(
      status: effectiveStatus,
      clientId: clientId,
      createdFrom: createdFrom,
      createdTo: createdTo,
      shippedFrom: shippedFrom,
      shippedTo: shippedTo,
      limit: limit,
      offset: offset,
      errorMessage: null,
      isLoading: true,
    );

    emit(nextState);

    try {
      final ordersResponse = await _repository.getAdminOrders(
        clientId: nextState.clientId,
        status: nextState.status,
        createdFrom: nextState.createdFrom,
        createdTo: nextState.createdTo,
        shippedFrom: nextState.shippedFrom,
        shippedTo: nextState.shippedTo,
        limit: nextState.limit,
        offset: nextState.offset,
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
    emit(const AdminOrdersState());
  }

  Future<void> searchOrderById(String query) async {
    if (query.trim().isEmpty) {
      emit(state.copyWith(
        searchQuery: null,
        searchedOrder: null,
        isSearching: false,
        errorMessage: null,
      ));
      return;
    }

    final orderId = int.tryParse(query.trim());
    if (orderId == null) {
      emit(state.copyWith(
        searchQuery: query,
        searchedOrder: null,
        isSearching: false,
        errorMessage: 'Номер заказа должен быть числом',
      ));
      return;
    }

    emit(state.copyWith(
      searchQuery: query,
      isSearching: true,
      errorMessage: null,
    ));

    try {
      final order = await _repository.getAdminOrderById(orderId);
      emit(state.copyWith(
        searchedOrder: order,
        isSearching: false,
        errorMessage: null,
      ));
    } on Exception catch (e) {
      emit(state.copyWith(
        searchedOrder: null,
        isSearching: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    } catch (_) {
      emit(state.copyWith(
        searchedOrder: null,
        isSearching: false,
        errorMessage: 'Заказ не найден',
      ));
    }
  }

  void clearSearch() {
    emit(state.copyWith(
      searchQuery: null,
      searchedOrder: null,
      isSearching: false,
      errorMessage: null,
    ));
  }
}
