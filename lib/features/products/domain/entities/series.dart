import 'package:prime_top_front/features/products/domain/entities/analyses.dart';

class Series {
  const Series({
    required this.id,
    this.name,
    this.productionDate,
    this.expireDate,
    this.analyses,
    this.availableQuantity = 0.0,
    this.inStock = false,
  });

  final int id;
  final String? name;
  final DateTime? productionDate;
  final DateTime? expireDate;
  final Analyses? analyses;
  final double availableQuantity;
  final bool inStock;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Series &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          productionDate == other.productionDate &&
          expireDate == other.expireDate &&
          analyses == other.analyses &&
          availableQuantity == other.availableQuantity &&
          inStock == other.inStock;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      productionDate.hashCode ^
      expireDate.hashCode ^
      analyses.hashCode ^
      availableQuantity.hashCode ^
      inStock.hashCode;
}

