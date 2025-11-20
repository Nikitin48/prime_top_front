import 'package:prime_top_front/features/products/domain/entities/analyses.dart';
import 'package:prime_top_front/features/products/domain/entities/product.dart';
import 'package:prime_top_front/features/coating_types/domain/entities/coating_type.dart';

class Stock {
  const Stock({
    required this.stocksId,
    this.seriesId,
    this.seriesName,
    this.productionDate,
    this.expireDate,
    required this.quantity,
    this.reservedForClient = false,
    required this.updatedAt,
    this.color,
    this.product,
    this.coatingType,
    this.analyses,
  });

  final int stocksId;
  final int? seriesId;
  final String? seriesName;
  final DateTime? productionDate;
  final DateTime? expireDate;
  final double quantity;
  final bool reservedForClient;
  final DateTime updatedAt;
  final int? color;
  final Product? product;
  final CoatingType? coatingType;
  final Analyses? analyses;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Stock &&
          runtimeType == other.runtimeType &&
          stocksId == other.stocksId &&
          seriesId == other.seriesId &&
          seriesName == other.seriesName &&
          productionDate == other.productionDate &&
          expireDate == other.expireDate &&
          quantity == other.quantity &&
          reservedForClient == other.reservedForClient &&
          updatedAt == other.updatedAt &&
          color == other.color &&
          product == other.product &&
          coatingType == other.coatingType &&
          analyses == other.analyses;

  @override
  int get hashCode =>
      stocksId.hashCode ^
      seriesId.hashCode ^
      seriesName.hashCode ^
      productionDate.hashCode ^
      expireDate.hashCode ^
      quantity.hashCode ^
      reservedForClient.hashCode ^
      updatedAt.hashCode ^
      color.hashCode ^
      product.hashCode ^
      coatingType.hashCode ^
      analyses.hashCode;
}
