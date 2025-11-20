import 'package:prime_top_front/features/stock/domain/entities/available_stocks_response.dart';

abstract class StockRepository {
  Future<AvailableStocksResponse> getAvailableStocks({
    int? clientId,
    String? color,
    String? coatingType,
    String? series,
    double? minQuantity,
    int? limit,
    int? offset,
  });
}
