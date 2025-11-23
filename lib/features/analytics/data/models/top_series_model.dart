import '../../domain/entities/top_series.dart';

class TopSeriesModel extends TopSeries {
  const TopSeriesModel({
    required super.topSeries,
  });

  factory TopSeriesModel.fromJson(Map<String, dynamic> json) {
    return TopSeriesModel(
      topSeries: (json['top_series'] as List?)
              ?.map((item) => SeriesStatsModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class SeriesStatsModel extends SeriesStats {
  const SeriesStatsModel({
    required super.seriesId,
    super.seriesName,
    required super.product,
    super.productionDate,
    required super.totalSold,
    required super.ordersCount,
    required super.currentStock,
  });

  factory SeriesStatsModel.fromJson(Map<String, dynamic> json) {
    return SeriesStatsModel(
      seriesId: json['series_id'] as int? ?? 0,
      seriesName: json['series_name'] as String?,
      product: ProductInfoModel.fromJson(
        json['product'] as Map<String, dynamic>? ?? {},
      ),
      productionDate: json['production_date'] as String?,
      totalSold: (json['total_sold'] as num?)?.toDouble() ?? 0.0,
      ordersCount: json['orders_count'] as int? ?? 0,
      currentStock: (json['current_stock'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class ProductInfoModel extends ProductInfo {
  const ProductInfoModel({
    required super.id,
    required super.name,
  });

  factory ProductInfoModel.fromJson(Map<String, dynamic> json) {
    return ProductInfoModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
    );
  }
}

