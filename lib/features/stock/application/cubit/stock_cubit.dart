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
    int? seriesId,
    bool? includePublic,
    bool? personalOnly,
    double? analysesBleskPri60Grad,
    double? analysesUslovnayaVyazkost,
    double? analysesDeltaE,
    double? analysesDeltaL,
    double? analysesDeltaA,
    double? analysesDeltaB,
    double? minAnalysesBleskPri60Grad,
    double? maxAnalysesBleskPri60Grad,
    double? minAnalysesUslovnayaVyazkost,
    double? maxAnalysesUslovnayaVyazkost,
    double? minAnalysesDeltaE,
    double? maxAnalysesDeltaE,
    double? minAnalysesDeltaL,
    double? maxAnalysesDeltaL,
    double? minAnalysesDeltaA,
    double? maxAnalysesDeltaA,
    double? minAnalysesDeltaB,
    double? maxAnalysesDeltaB,
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
        seriesId: seriesId,
        includePublic: includePublic,
        personalOnly: personalOnly,
        analysesBleskPri60Grad: analysesBleskPri60Grad,
        analysesUslovnayaVyazkost: analysesUslovnayaVyazkost,
        analysesDeltaE: analysesDeltaE,
        analysesDeltaL: analysesDeltaL,
        analysesDeltaA: analysesDeltaA,
        analysesDeltaB: analysesDeltaB,
        minAnalysesBleskPri60Grad: minAnalysesBleskPri60Grad,
        maxAnalysesBleskPri60Grad: maxAnalysesBleskPri60Grad,
        minAnalysesUslovnayaVyazkost: minAnalysesUslovnayaVyazkost,
        maxAnalysesUslovnayaVyazkost: maxAnalysesUslovnayaVyazkost,
        minAnalysesDeltaE: minAnalysesDeltaE,
        maxAnalysesDeltaE: maxAnalysesDeltaE,
        minAnalysesDeltaL: minAnalysesDeltaL,
        maxAnalysesDeltaL: maxAnalysesDeltaL,
        minAnalysesDeltaA: minAnalysesDeltaA,
        maxAnalysesDeltaA: maxAnalysesDeltaA,
        minAnalysesDeltaB: minAnalysesDeltaB,
        maxAnalysesDeltaB: maxAnalysesDeltaB,
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
    int? seriesId,
    bool? includePublic,
    bool? personalOnly,
    double? analysesBleskPri60Grad,
    double? analysesUslovnayaVyazkost,
    double? analysesDeltaE,
    double? analysesDeltaL,
    double? analysesDeltaA,
    double? analysesDeltaB,
    double? minAnalysesBleskPri60Grad,
    double? maxAnalysesBleskPri60Grad,
    double? minAnalysesUslovnayaVyazkost,
    double? maxAnalysesUslovnayaVyazkost,
    double? minAnalysesDeltaE,
    double? maxAnalysesDeltaE,
    double? minAnalysesDeltaL,
    double? maxAnalysesDeltaL,
    double? minAnalysesDeltaA,
    double? maxAnalysesDeltaA,
    double? minAnalysesDeltaB,
    double? maxAnalysesDeltaB,
  }) {
    emit(state.copyWith(
      filters: state.filters.copyWith(
        color: () => color,
        coatingType: () => coatingType,
        series: () => series,
        seriesId: () => seriesId,
        includePublic: () => includePublic,
        personalOnly: () => personalOnly,
        analysesBleskPri60Grad: () => analysesBleskPri60Grad,
        analysesUslovnayaVyazkost: () => analysesUslovnayaVyazkost,
        analysesDeltaE: () => analysesDeltaE,
        analysesDeltaL: () => analysesDeltaL,
        analysesDeltaA: () => analysesDeltaA,
        analysesDeltaB: () => analysesDeltaB,
        minAnalysesBleskPri60Grad: () => minAnalysesBleskPri60Grad,
        maxAnalysesBleskPri60Grad: () => maxAnalysesBleskPri60Grad,
        minAnalysesUslovnayaVyazkost: () => minAnalysesUslovnayaVyazkost,
        maxAnalysesUslovnayaVyazkost: () => maxAnalysesUslovnayaVyazkost,
        minAnalysesDeltaE: () => minAnalysesDeltaE,
        maxAnalysesDeltaE: () => maxAnalysesDeltaE,
        minAnalysesDeltaL: () => minAnalysesDeltaL,
        maxAnalysesDeltaL: () => maxAnalysesDeltaL,
        minAnalysesDeltaA: () => minAnalysesDeltaA,
        maxAnalysesDeltaA: () => maxAnalysesDeltaA,
        minAnalysesDeltaB: () => minAnalysesDeltaB,
        maxAnalysesDeltaB: () => maxAnalysesDeltaB,
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
    this.seriesId,
    this.includePublic,
    this.personalOnly,
    // Точные значения анализов
    this.analysesBleskPri60Grad,
    this.analysesUslovnayaVyazkost,
    this.analysesDeltaE,
    this.analysesDeltaL,
    this.analysesDeltaA,
    this.analysesDeltaB,
    // Диапазоны анализов
    this.minAnalysesBleskPri60Grad,
    this.maxAnalysesBleskPri60Grad,
    this.minAnalysesUslovnayaVyazkost,
    this.maxAnalysesUslovnayaVyazkost,
    this.minAnalysesDeltaE,
    this.maxAnalysesDeltaE,
    this.minAnalysesDeltaL,
    this.maxAnalysesDeltaL,
    this.minAnalysesDeltaA,
    this.maxAnalysesDeltaA,
    this.minAnalysesDeltaB,
    this.maxAnalysesDeltaB,
  });

  // Фильтры по продуктам
  final String? color;
  final String? coatingType;
  
  // Фильтры по сериям
  final String? series;
  final int? seriesId;
  
  // Фильтры по клиентам
  final bool? includePublic;
  final bool? personalOnly;
  
  // Точные значения анализов
  final double? analysesBleskPri60Grad;
  final double? analysesUslovnayaVyazkost;
  final double? analysesDeltaE;
  final double? analysesDeltaL;
  final double? analysesDeltaA;
  final double? analysesDeltaB;
  
  // Диапазоны анализов
  final double? minAnalysesBleskPri60Grad;
  final double? maxAnalysesBleskPri60Grad;
  final double? minAnalysesUslovnayaVyazkost;
  final double? maxAnalysesUslovnayaVyazkost;
  final double? minAnalysesDeltaE;
  final double? maxAnalysesDeltaE;
  final double? minAnalysesDeltaL;
  final double? maxAnalysesDeltaL;
  final double? minAnalysesDeltaA;
  final double? maxAnalysesDeltaA;
  final double? minAnalysesDeltaB;
  final double? maxAnalysesDeltaB;

  StockFilters copyWith({
    String? Function()? color,
    String? Function()? coatingType,
    String? Function()? series,
    int? Function()? seriesId,
    bool? Function()? includePublic,
    bool? Function()? personalOnly,
    double? Function()? analysesBleskPri60Grad,
    double? Function()? analysesUslovnayaVyazkost,
    double? Function()? analysesDeltaE,
    double? Function()? analysesDeltaL,
    double? Function()? analysesDeltaA,
    double? Function()? analysesDeltaB,
    double? Function()? minAnalysesBleskPri60Grad,
    double? Function()? maxAnalysesBleskPri60Grad,
    double? Function()? minAnalysesUslovnayaVyazkost,
    double? Function()? maxAnalysesUslovnayaVyazkost,
    double? Function()? minAnalysesDeltaE,
    double? Function()? maxAnalysesDeltaE,
    double? Function()? minAnalysesDeltaL,
    double? Function()? maxAnalysesDeltaL,
    double? Function()? minAnalysesDeltaA,
    double? Function()? maxAnalysesDeltaA,
    double? Function()? minAnalysesDeltaB,
    double? Function()? maxAnalysesDeltaB,
    bool clearColor = false,
    bool clearCoatingType = false,
    bool clearSeries = false,
    bool clearSeriesId = false,
    bool clearIncludePublic = false,
    bool clearPersonalOnly = false,
    bool clearAllAnalyses = false,
  }) {
    return StockFilters(
      color: clearColor ? null : (color != null ? color() : this.color),
      coatingType: clearCoatingType
          ? null
          : (coatingType != null ? coatingType() : this.coatingType),
      series: clearSeries ? null : (series != null ? series() : this.series),
      seriesId: clearSeriesId ? null : (seriesId != null ? seriesId() : this.seriesId),
      includePublic: clearIncludePublic
          ? null
          : (includePublic != null ? includePublic() : this.includePublic),
      personalOnly: clearPersonalOnly
          ? null
          : (personalOnly != null ? personalOnly() : this.personalOnly),
      analysesBleskPri60Grad: clearAllAnalyses
          ? null
          : (analysesBleskPri60Grad != null
              ? analysesBleskPri60Grad()
              : this.analysesBleskPri60Grad),
      analysesUslovnayaVyazkost: clearAllAnalyses
          ? null
          : (analysesUslovnayaVyazkost != null
              ? analysesUslovnayaVyazkost()
              : this.analysesUslovnayaVyazkost),
      analysesDeltaE: clearAllAnalyses
          ? null
          : (analysesDeltaE != null ? analysesDeltaE() : this.analysesDeltaE),
      analysesDeltaL: clearAllAnalyses
          ? null
          : (analysesDeltaL != null ? analysesDeltaL() : this.analysesDeltaL),
      analysesDeltaA: clearAllAnalyses
          ? null
          : (analysesDeltaA != null ? analysesDeltaA() : this.analysesDeltaA),
      analysesDeltaB: clearAllAnalyses
          ? null
          : (analysesDeltaB != null ? analysesDeltaB() : this.analysesDeltaB),
      minAnalysesBleskPri60Grad: clearAllAnalyses
          ? null
          : (minAnalysesBleskPri60Grad != null
              ? minAnalysesBleskPri60Grad()
              : this.minAnalysesBleskPri60Grad),
      maxAnalysesBleskPri60Grad: clearAllAnalyses
          ? null
          : (maxAnalysesBleskPri60Grad != null
              ? maxAnalysesBleskPri60Grad()
              : this.maxAnalysesBleskPri60Grad),
      minAnalysesUslovnayaVyazkost: clearAllAnalyses
          ? null
          : (minAnalysesUslovnayaVyazkost != null
              ? minAnalysesUslovnayaVyazkost()
              : this.minAnalysesUslovnayaVyazkost),
      maxAnalysesUslovnayaVyazkost: clearAllAnalyses
          ? null
          : (maxAnalysesUslovnayaVyazkost != null
              ? maxAnalysesUslovnayaVyazkost()
              : this.maxAnalysesUslovnayaVyazkost),
      minAnalysesDeltaE: clearAllAnalyses
          ? null
          : (minAnalysesDeltaE != null ? minAnalysesDeltaE() : this.minAnalysesDeltaE),
      maxAnalysesDeltaE: clearAllAnalyses
          ? null
          : (maxAnalysesDeltaE != null ? maxAnalysesDeltaE() : this.maxAnalysesDeltaE),
      minAnalysesDeltaL: clearAllAnalyses
          ? null
          : (minAnalysesDeltaL != null ? minAnalysesDeltaL() : this.minAnalysesDeltaL),
      maxAnalysesDeltaL: clearAllAnalyses
          ? null
          : (maxAnalysesDeltaL != null ? maxAnalysesDeltaL() : this.maxAnalysesDeltaL),
      minAnalysesDeltaA: clearAllAnalyses
          ? null
          : (minAnalysesDeltaA != null ? minAnalysesDeltaA() : this.minAnalysesDeltaA),
      maxAnalysesDeltaA: clearAllAnalyses
          ? null
          : (maxAnalysesDeltaA != null ? maxAnalysesDeltaA() : this.maxAnalysesDeltaA),
      minAnalysesDeltaB: clearAllAnalyses
          ? null
          : (minAnalysesDeltaB != null ? minAnalysesDeltaB() : this.minAnalysesDeltaB),
      maxAnalysesDeltaB: clearAllAnalyses
          ? null
          : (maxAnalysesDeltaB != null ? maxAnalysesDeltaB() : this.maxAnalysesDeltaB),
    );
  }

  @override
  List<Object?> get props => [
        color,
        coatingType,
        series,
        seriesId,
        includePublic,
        personalOnly,
        analysesBleskPri60Grad,
        analysesUslovnayaVyazkost,
        analysesDeltaE,
        analysesDeltaL,
        analysesDeltaA,
        analysesDeltaB,
        minAnalysesBleskPri60Grad,
        maxAnalysesBleskPri60Grad,
        minAnalysesUslovnayaVyazkost,
        maxAnalysesUslovnayaVyazkost,
        minAnalysesDeltaE,
        maxAnalysesDeltaE,
        minAnalysesDeltaL,
        maxAnalysesDeltaL,
        minAnalysesDeltaA,
        maxAnalysesDeltaA,
        minAnalysesDeltaB,
        maxAnalysesDeltaB,
      ];
}
