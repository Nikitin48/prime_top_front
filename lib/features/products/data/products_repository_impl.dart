import 'package:prime_top_front/core/network/exceptions.dart';
import 'package:prime_top_front/features/products/data/datasources/products_remote_data_source.dart';
import 'package:prime_top_front/features/products/domain/entities/product_detail.dart';
import 'package:prime_top_front/features/products/domain/repositories/products_repository.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  ProductsRepositoryImpl(this._remoteDataSource);

  final ProductsRemoteDataSource _remoteDataSource;

  @override
  Future<ProductsResponse> getProducts({
    int? coatingTypeId,
    String? name,
    String? nomenclature,
    String? color,
    int? minPrice,
    int? maxPrice,
    int? limit,
    int? offset,
  }) async {
    try {
      final dataResponse = await _remoteDataSource.getProducts(
        coatingTypeId: coatingTypeId,
        name: name,
        nomenclature: nomenclature,
        color: color,
        minPrice: minPrice,
        maxPrice: maxPrice,
        limit: limit,
        offset: offset,
      );
      return ProductsResponse(
        products: dataResponse.products.map((model) => model.toEntity()).toList(),
        count: dataResponse.count,
      );
    } on NetworkException catch (e) {
      throw Exception('Ошибка сети: ${e.message}');
    } catch (e) {
      throw Exception('Неожиданная ошибка при получении продуктов: $e');
    }
  }

  @override
  Future<ProductsResponse> searchProducts({
    required String query,
    int? limit,
    int? offset,
  }) async {
    try {
      final dataResponse = await _remoteDataSource.searchProducts(
        query: query,
        limit: limit,
        offset: offset,
      );
      return ProductsResponse(
        products: dataResponse.products.map((model) => model.toEntity()).toList(),
        count: dataResponse.count,
      );
    } on NetworkException catch (e) {
      throw Exception('Ошибка сети: ${e.message}');
    } catch (e) {
      throw Exception('Неожиданная ошибка при поиске продуктов: $e');
    }
  }

  @override
  Future<ProductDetail> getProductDetail(int productId) async {
    try {
      final dataResponse = await _remoteDataSource.getProductDetail(productId);
      return dataResponse.toEntity();
    } on NetworkException catch (e) {
      throw Exception('Ошибка сети: ${e.message}');
    } catch (e) {
      throw Exception('Неожиданная ошибка при получении детальной информации о продукте: $e');
    }
  }
}
