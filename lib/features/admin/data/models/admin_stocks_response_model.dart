import 'package:prime_top_front/features/admin/data/models/admin_stock_model.dart';
import 'package:prime_top_front/features/admin/domain/entities/admin_stocks_response.dart';

class AdminStocksResponseModel extends AdminStocksResponse {
  const AdminStocksResponseModel({
    required super.count,
    required super.results,
  });

  factory AdminStocksResponseModel.fromJson(Map<String, dynamic> json) {
    final count = json['count'] is int ? json['count'] as int : 0;
    
    final results = <AdminStockModel>[];
    if (json['results'] is List) {
      final resultsList = json['results'] as List;
      results.addAll(
        resultsList
            .map((item) {
              try {
                if (item is Map<String, dynamic>) {
                  return AdminStockModel.fromJson(item);
                }
              } catch (e) {
              }
              return null;
            })
            .whereType<AdminStockModel>(),
      );
    }

    return AdminStocksResponseModel(
      count: count,
      results: results,
    );
  }

  AdminStocksResponse toEntity() {
    return AdminStocksResponse(
      count: count,
      results: results.map((stock) {
        if (stock is AdminStockModel) {
          return stock.toEntity();
        }
        return stock;
      }).toList(),
    );
  }
}
