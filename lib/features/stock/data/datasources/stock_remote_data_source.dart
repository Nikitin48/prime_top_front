import 'package:prime_top_front/features/stock/data/models/available_stocks_response_model.dart';

abstract class StockRemoteDataSource {
  Future<AvailableStocksResponseModel> getAvailableStocks({
    int? clientId,
    String? color,
    String? coatingType,
    String? series,
    double? minQuantity,
    int? limit,
    int? offset,
  });
}
