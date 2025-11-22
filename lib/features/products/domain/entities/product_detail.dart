import 'package:prime_top_front/features/products/domain/entities/product.dart';
import 'package:prime_top_front/features/products/domain/entities/series.dart';

class ProductDetail {
  const ProductDetail({
    required this.product,
    required this.series,
    required this.seriesCount,
  });

  final Product product;
  final List<Series> series;
  final int seriesCount;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductDetail &&
          runtimeType == other.runtimeType &&
          product == other.product &&
          series == other.series &&
          seriesCount == other.seriesCount;

  @override
  int get hashCode =>
      product.hashCode ^
      series.hashCode ^
      seriesCount.hashCode;
}
