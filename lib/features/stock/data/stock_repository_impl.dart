import 'package:prime_top_front/core/network/exceptions.dart';
import 'package:prime_top_front/features/stock/data/datasources/stock_remote_data_source.dart';
import 'package:prime_top_front/features/stock/domain/entities/available_stocks_response.dart';
import 'package:prime_top_front/features/stock/domain/repositories/stock_repository.dart';

class StockRepositoryImpl implements StockRepository {
  StockRepositoryImpl(this._remoteDataSource);

  final StockRemoteDataSource _remoteDataSource;

  @override
  Future<AvailableStocksResponse> getAvailableStocks({
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
    try {
      final response = await _remoteDataSource.getAvailableStocks(
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
      return response.toEntity();
    } on NetworkException catch (e) {
      throw Exception('Ошибка сети: ${e.message}');
    } catch (e) {
      throw Exception('Неожиданная ошибка при получении остатков: $e');
    }
  }
}
