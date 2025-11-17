import 'package:prime_top_front/features/products/domain/entities/product.dart';

class ProductsResponse {
  const ProductsResponse({
    required this.products,
    required this.count,
  });

  final List<Product> products;
  final int count;
}

abstract class ProductsRepository {
  Future<ProductsResponse> getProducts({
    int? coatingTypeId,
    String? name,
    String? nomenclature,
    String? color,
    int? minPrice,
    int? maxPrice,
    int? limit,
    int? offset,
  });
}

