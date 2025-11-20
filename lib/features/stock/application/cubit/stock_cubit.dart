import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_top_front/features/stock/domain/entities/available_stocks_response.dart';
import 'package:prime_top_front/features/stock/domain/repositories/stock_repository.dart';

part 'stock_state.dart';

class StockCubit extends Cubit<StockState> {
  StockCubit(this._repository) : super(const StockState.initial());

  final StockRepository _repository;

  Future<void> loadStocks({
    int? clientId,
    String? color,
    String? coatingType,
    String? series,
    double? minQuantity,
    int? limit,
    int? offset,
  }) async {
    emit(state.copyWith(status: StockStatus.loading));
    try {
      final response = await _repository.getAvailableStocks(
        clientId: clientId,
        color: color,
        coatingType: coatingType,
        series: series,
        minQuantity: minQuantity,
        limit: limit,
        offset: offset,
      );
      emit(state.copyWith(
        status: StockStatus.success,
        response: response,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: StockStatus.failure,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    }
  }

  void resetFilters() {
    emit(state.copyWith(
      filters: const StockFilters(),
    ));
  }

  void updateFilters({
    String? color,
    String? coatingType,
    String? series,
    double? minQuantity,
  }) {
    emit(state.copyWith(
      filters: state.filters.copyWith(
        color: () => color,
        coatingType: () => coatingType,
        series: () => series,
        minQuantity: () => minQuantity,
      ),
    ));
  }
}

enum StockStatus { initial, loading, success, failure }

class StockFilters extends Equatable {
  const StockFilters({
    this.color,
    this.coatingType,
    this.series,
    this.minQuantity,
  });

  final String? color;
  final String? coatingType;
  final String? series;
  final double? minQuantity;

  StockFilters copyWith({
    String? Function()? color,
    String? Function()? coatingType,
    String? Function()? series,
    double? Function()? minQuantity,
    bool clearColor = false,
    bool clearCoatingType = false,
    bool clearSeries = false,
    bool clearMinQuantity = false,
  }) {
    return StockFilters(
      color: clearColor ? null : (color != null ? color() : this.color),
      coatingType: clearCoatingType
          ? null
          : (coatingType != null ? coatingType() : this.coatingType),
      series:
          clearSeries ? null : (series != null ? series() : this.series),
      minQuantity: clearMinQuantity
          ? null
          : (minQuantity != null ? minQuantity() : this.minQuantity),
    );
  }

  @override
  List<Object?> get props => [color, coatingType, series, minQuantity];
}
