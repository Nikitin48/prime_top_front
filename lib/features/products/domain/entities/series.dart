import 'package:prime_top_front/features/products/domain/entities/analyses.dart';

class Series {
  const Series({
    required this.id,
    this.name,
    this.productionDate,
    this.expireDate,
    this.analyses,
  });

  final int id;
  final String? name;
  final DateTime? productionDate;
  final DateTime? expireDate;
  final Analyses? analyses;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Series &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          productionDate == other.productionDate &&
          expireDate == other.expireDate &&
          analyses == other.analyses;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      productionDate.hashCode ^
      expireDate.hashCode ^
      analyses.hashCode;
}

