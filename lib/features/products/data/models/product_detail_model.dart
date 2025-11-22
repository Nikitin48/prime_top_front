import 'package:prime_top_front/features/products/data/models/product_model.dart';
import 'package:prime_top_front/features/products/data/models/series_model.dart';
import 'package:prime_top_front/features/products/domain/entities/product_detail.dart';

class ProductDetailModel extends ProductDetail {
  const ProductDetailModel({
    required ProductModel product,
    required List<SeriesModel> series,
    required int seriesCount,
  }) : _seriesModels = series,
       super(
         product: product,
         series: series,
         seriesCount: seriesCount,
       );

  final List<SeriesModel> _seriesModels;

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailModel(
      product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
      series: (json['series'] as List<dynamic>)
          .map((item) => SeriesModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      seriesCount: json['series_count'] as int,
    );
  }

  ProductDetail toEntity() {
    return ProductDetail(
      product: product,
      series: _seriesModels.map((s) => s.toEntity()).toList(),
      seriesCount: seriesCount,
    );
  }
}
