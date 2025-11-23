import 'package:equatable/equatable.dart';

class TopCoatingTypes extends Equatable {
  const TopCoatingTypes({
    required this.coatingTypesBreakdown,
    required this.total,
  });

  final List<CoatingTypeStats> coatingTypesBreakdown;
  final TotalInfo total;

  @override
  List<Object?> get props => [coatingTypesBreakdown, total];
}

class CoatingTypeStats extends Equatable {
  const CoatingTypeStats({
    required this.coatingTypeId,
    required this.coatingTypeName,
    required this.nomenclature,
    required this.totalQuantity,
    required this.totalRevenue,
    required this.ordersCount,
    required this.percentageOfTotal,
  });

  final int coatingTypeId;
  final String coatingTypeName;
  final String nomenclature;
  final double totalQuantity;
  final double totalRevenue;
  final int ordersCount;
  final double percentageOfTotal;

  @override
  List<Object?> get props => [
        coatingTypeId,
        coatingTypeName,
        nomenclature,
        totalQuantity,
        totalRevenue,
        ordersCount,
        percentageOfTotal,
      ];
}

class TotalInfo extends Equatable {
  const TotalInfo({
    required this.quantity,
    required this.revenue,
    required this.ordersCount,
  });

  final double quantity;
  final double revenue;
  final int ordersCount;

  @override
  List<Object?> get props => [quantity, revenue, ordersCount];
}

