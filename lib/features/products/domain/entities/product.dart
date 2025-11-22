import 'package:prime_top_front/features/coating_types/domain/entities/coating_type.dart';

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.colorCode,
    required this.price,
    required this.coatingType,
  });

  final int id;
  final String name;
  final int colorCode;
  final int price;
  final CoatingType coatingType;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          colorCode == other.colorCode &&
          price == other.price &&
          coatingType == other.coatingType;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      colorCode.hashCode ^
      price.hashCode ^
      coatingType.hashCode;
}
