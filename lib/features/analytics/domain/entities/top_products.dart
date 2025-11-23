import 'package:equatable/equatable.dart';

class PeriodInfo extends Equatable {
  const PeriodInfo({
    this.from,
    this.to,
    required this.groupBy,
  });

  final String? from;
  final String? to;
  final String groupBy;

  @override
  List<Object?> get props => [from, to, groupBy];
}

class TopProducts extends Equatable {
  const TopProducts({
    required this.period,
    required this.topByQuantity,
    required this.topByRevenue,
    required this.topByOrders,
  });

  final PeriodInfo period;
  final List<ProductStats> topByQuantity;
  final List<ProductStats> topByRevenue;
  final List<ProductStats> topByOrders;

  @override
  List<Object?> get props => [period, topByQuantity, topByRevenue, topByOrders];
}

class ProductStats extends Equatable {
  const ProductStats({
    required this.productId,
    required this.productName,
    required this.coatingType,
    required this.totalQuantity,
    required this.ordersCount,
    required this.totalRevenue,
  });

  final int productId;
  final String productName;
  final CoatingTypeInfo coatingType;
  final double totalQuantity;
  final int ordersCount;
  final double totalRevenue;

  @override
  List<Object?> get props => [
        productId,
        productName,
        coatingType,
        totalQuantity,
        ordersCount,
        totalRevenue,
      ];
}

class CoatingTypeInfo extends Equatable {
  const CoatingTypeInfo({
    required this.id,
    required this.name,
    required this.nomenclature,
  });

  final int id;
  final String name;
  final String nomenclature;

  @override
  List<Object?> get props => [id, name, nomenclature];
}

