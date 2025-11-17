import 'package:prime_top_front/features/products/data/models/product_detail_model.dart';
import 'package:prime_top_front/features/products/data/models/product_model.dart';

class ProductsDataResponse {
  const ProductsDataResponse({
    required this.products,
    required this.count,
  });

  final List<ProductModel> products;
  final int count;
}

abstract class ProductsRemoteDataSource {
  Future<ProductsDataResponse> getProducts({
    int? coatingTypeId,
    String? name,
    String? nomenclature,
    String? color,
    int? minPrice,
    int? maxPrice,
    int? limit,
    int? offset,
  });

  Future<ProductDetailModel> getProductDetail(int productId);
}

