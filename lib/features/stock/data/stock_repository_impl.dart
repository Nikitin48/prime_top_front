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
    double? minQuantity,
    int? limit,
    int? offset,
  }) async {
    try {
      final response = await _remoteDataSource.getAvailableStocks(
        clientId: clientId,
        color: color,
        coatingType: coatingType,
        series: series,
        minQuantity: minQuantity,
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
