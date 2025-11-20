import 'package:prime_top_front/features/home/data/models/popular_product_model.dart';
import 'package:prime_top_front/features/home/domain/entities/top_products_response.dart';

class TopProductsResponseModel extends TopProductsResponse {
  const TopProductsResponseModel({
    required super.count,
    required super.results,
  });

  factory TopProductsResponseModel.fromJson(Map<String, dynamic> json) {
    final count = json['count'] as int? ?? 0;
    final resultsJson = json['results'] as List<dynamic>? ?? [];

    return TopProductsResponseModel(
      count: count,
      results: resultsJson
          .map((productJson) {
            final productData = productJson as Map<String, dynamic>;
            // coating_type может быть null по документации, но обычно присутствует
            final coatingTypeJson = productData['coating_type'];
            if (coatingTypeJson != null) {
              return PopularProductModel.fromJson(
                productData,
                coatingTypeJson as Map<String, dynamic>,
              );
            } else {
              // Если coating_type отсутствует, создаем дефолтный тип покрытия
              return PopularProductModel.fromJson(
                productData,
                {
                  'id': 0,
                  'name': 'Неизвестно',
                  'nomenclature': '',
                },
              );
            }
          })
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'results': results
          .map((result) => (result as PopularProductModel).toJson())
          .toList(),
    };
  }

  TopProductsResponse toEntity() {
    return TopProductsResponse(
      count: count,
      results: results,
    );
  }
}

