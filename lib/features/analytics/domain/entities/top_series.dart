import 'package:equatable/equatable.dart';

class TopSeries extends Equatable {
  const TopSeries({
    required this.topSeries,
  });

  final List<SeriesStats> topSeries;

  @override
  List<Object?> get props => [topSeries];
}

class SeriesStats extends Equatable {
  const SeriesStats({
    required this.seriesId,
    this.seriesName,
    required this.product,
    this.productionDate,
    required this.totalSold,
    required this.ordersCount,
    required this.currentStock,
  });

  final int seriesId;
  final String? seriesName;
  final ProductInfo product;
  final String? productionDate;
  final double totalSold;
  final int ordersCount;
  final double currentStock;

  @override
  List<Object?> get props => [
        seriesId,
        seriesName,
        product,
        productionDate,
        totalSold,
        ordersCount,
        currentStock,
      ];
}

class ProductInfo extends Equatable {
  const ProductInfo({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  @override
  List<Object?> get props => [id, name];
}

