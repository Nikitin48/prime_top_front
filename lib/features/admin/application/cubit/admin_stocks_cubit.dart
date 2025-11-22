import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_top_front/features/admin/domain/entities/admin_stock.dart';
import 'package:prime_top_front/features/admin/domain/repositories/admin_repository.dart';

part 'admin_stocks_state.dart';

class AdminStocksCubit extends Cubit<AdminStocksState> {
  AdminStocksCubit(this._repository) : super(const AdminStocksState.initial());

  final AdminRepository _repository;
  int _requestToken = 0;

  Future<void> loadStocks({
    int? limit,
    int? offset,
  }) async {
    _requestToken++;
    final currentToken = _requestToken;

    emit(state.copyWith(status: AdminStocksStatus.loading));
    try {
      final response = await _repository.getAdminStocks(
        limit: limit,
        offset: offset,
      );

      if (currentToken != _requestToken) {
        return;
      }

      emit(state.copyWith(
        status: AdminStocksStatus.success,
        stocks: response.results,
        totalCount: response.count,
      ));
    } catch (e) {
      if (currentToken != _requestToken) {
        return;
      }

      emit(state.copyWith(
        status: AdminStocksStatus.failure,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  Future<void> updateStock({
    required int stockId,
    int? seriesId,
    int? clientId,
    double? quantity,
    bool? isReserved,
    int? limit,
    int? offset,
  }) async {
    try {
      await _repository.updateStock(
        stockId: stockId,
        seriesId: seriesId,
        clientId: clientId,
        quantity: quantity,
        isReserved: isReserved,
      );

      await loadStocks(limit: limit, offset: offset);
    } on Exception catch (e) {
      final errorMessage = e.toString();
      if (errorMessage.contains('cancel') || errorMessage.contains('Cancel')) {
        return;
      }
      emit(state.copyWith(
        errorMessage: errorMessage.replaceFirst('Exception: ', ''),
      ));
    } catch (e) {
      final errorMessage = e.toString();
      if (errorMessage.contains('cancel') || errorMessage.contains('Cancel')) {
        return;
      }
      emit(state.copyWith(
        errorMessage: 'Ошибка обновления остатка: $errorMessage',
      ));
    }
  }

  Future<void> createStock({
    required int seriesId,
    int? clientId,
    required double quantity,
    bool? isReserved,
    int? limit,
    int? offset,
  }) async {
    try {
      await _repository.createStock(
        seriesId: seriesId,
        clientId: clientId,
        quantity: quantity,
        isReserved: isReserved,
      );

      await loadStocks(limit: limit, offset: offset);
    } on Exception catch (e) {
      final errorMessage = e.toString();
      if (errorMessage.contains('cancel') || errorMessage.contains('Cancel')) {
        return;
      }
      emit(state.copyWith(
        errorMessage: errorMessage.replaceFirst('Exception: ', ''),
      ));
    } catch (e) {
      final errorMessage = e.toString();
      if (errorMessage.contains('cancel') || errorMessage.contains('Cancel')) {
        return;
      }
      emit(state.copyWith(
        errorMessage: 'Ошибка создания остатка: $errorMessage',
      ));
    }
  }

  Future<void> deleteStock(int stockId, {int? limit, int? offset}) async {
    try {
      await _repository.deleteStock(stockId);

      await loadStocks(limit: limit, offset: offset);
    } on Exception catch (e) {
      final errorMessage = e.toString();
      if (errorMessage.contains('cancel') || errorMessage.contains('Cancel')) {
        return;
      }
      emit(state.copyWith(
        errorMessage: errorMessage.replaceFirst('Exception: ', ''),
      ));
    } catch (e) {
      final errorMessage = e.toString();
      if (errorMessage.contains('cancel') || errorMessage.contains('Cancel')) {
        return;
      }
      emit(state.copyWith(
        errorMessage: 'Ошибка удаления остатка: $errorMessage',
      ));
    }
  }

  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }
}
