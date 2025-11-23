import '../../domain/entities/top_products.dart';

class PeriodInfoModel extends PeriodInfo {
  const PeriodInfoModel({
    super.from,
    super.to,
    required super.groupBy,
  });

  factory PeriodInfoModel.fromJson(Map<String, dynamic> json) {
    return PeriodInfoModel(
      from: json['from'] as String?,
      to: json['to'] as String?,
      groupBy: json['group_by'] as String? ?? 'month',
    );
  }
}

class TopProductsModel extends TopProducts {
  const TopProductsModel({
    required super.period,
    required super.topByQuantity,
    required super.topByRevenue,
    required super.topByOrders,
  });

  factory TopProductsModel.fromJson(Map<String, dynamic> json) {
    return TopProductsModel(
      period: PeriodInfoModel.fromJson(json['period'] as Map<String, dynamic>? ?? {}),
      topByQuantity: (json['top_by_quantity'] as List?)
              ?.map((item) => ProductStatsModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      topByRevenue: (json['top_by_revenue'] as List?)
              ?.map((item) => ProductStatsModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      topByOrders: (json['top_by_orders'] as List?)
              ?.map((item) => ProductStatsModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class ProductStatsModel extends ProductStats {
  const ProductStatsModel({
    required super.productId,
    required super.productName,
    required super.coatingType,
    required super.totalQuantity,
    required super.ordersCount,
    required super.totalRevenue,
  });

  factory ProductStatsModel.fromJson(Map<String, dynamic> json) {
    return ProductStatsModel(
      productId: json['product_id'] as int? ?? 0,
      productName: json['product_name'] as String? ?? '',
      coatingType: CoatingTypeInfoModel.fromJson(
        json['coating_type'] as Map<String, dynamic>? ?? {},
      ),
      totalQuantity: (json['total_quantity'] as num?)?.toDouble() ?? 0.0,
      ordersCount: json['orders_count'] as int? ?? 0,
      totalRevenue: (json['total_revenue'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class CoatingTypeInfoModel extends CoatingTypeInfo {
  const CoatingTypeInfoModel({
    required super.id,
    required super.name,
    required super.nomenclature,
  });

  factory CoatingTypeInfoModel.fromJson(Map<String, dynamic> json) {
    return CoatingTypeInfoModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      nomenclature: json['nomenclature'] as String? ?? '',
    );
  }
}

