import '../../domain/entities/top_coating_types.dart';

class TopCoatingTypesModel extends TopCoatingTypes {
  const TopCoatingTypesModel({
    required super.coatingTypesBreakdown,
    required super.total,
  });

  factory TopCoatingTypesModel.fromJson(Map<String, dynamic> json) {
    return TopCoatingTypesModel(
      coatingTypesBreakdown: (json['coating_types_breakdown'] as List?)
              ?.map((item) => CoatingTypeStatsModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      total: TotalInfoModel.fromJson(json['total'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class CoatingTypeStatsModel extends CoatingTypeStats {
  const CoatingTypeStatsModel({
    required super.coatingTypeId,
    required super.coatingTypeName,
    required super.nomenclature,
    required super.totalQuantity,
    required super.totalRevenue,
    required super.ordersCount,
    required super.percentageOfTotal,
  });

  factory CoatingTypeStatsModel.fromJson(Map<String, dynamic> json) {
    return CoatingTypeStatsModel(
      coatingTypeId: json['coating_type_id'] as int? ?? 0,
      coatingTypeName: json['coating_type_name'] as String? ?? '',
      nomenclature: json['nomenclature'] as String? ?? '',
      totalQuantity: (json['total_quantity'] as num?)?.toDouble() ?? 0.0,
      totalRevenue: (json['total_revenue'] as num?)?.toDouble() ?? 0.0,
      ordersCount: json['orders_count'] as int? ?? 0,
      percentageOfTotal: (json['percentage_of_total'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class TotalInfoModel extends TotalInfo {
  const TotalInfoModel({
    required super.quantity,
    required super.revenue,
    required super.ordersCount,
  });

  factory TotalInfoModel.fromJson(Map<String, dynamic> json) {
    return TotalInfoModel(
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0.0,
      revenue: (json['revenue'] as num?)?.toDouble() ?? 0.0,
      ordersCount: json['orders_count'] as int? ?? 0,
    );
  }
}

