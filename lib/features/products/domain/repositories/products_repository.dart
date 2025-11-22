import 'package:prime_top_front/features/products/domain/entities/product.dart';
import 'package:prime_top_front/features/products/domain/entities/product_detail.dart';

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

  Future<ProductsResponse> searchProducts({
    required String query,
    int? limit,
    int? offset,
  });

  Future<ProductDetail> getProductDetail(int productId);
}

