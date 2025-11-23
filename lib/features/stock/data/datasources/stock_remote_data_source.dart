import 'package:prime_top_front/features/stock/data/models/available_stocks_response_model.dart';

abstract class StockRemoteDataSource {
  Future<AvailableStocksResponseModel> getAvailableStocks({
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
  });
}
