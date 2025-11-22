import 'package:prime_top_front/core/network/exceptions.dart';
import 'package:prime_top_front/features/home/data/datasources/top_products_remote_data_source.dart';
import 'package:prime_top_front/features/home/domain/entities/top_products_response.dart';
import 'package:prime_top_front/features/home/domain/repositories/top_products_repository.dart';

class TopProductsRepositoryImpl implements TopProductsRepository {
  TopProductsRepositoryImpl(this._remoteDataSource);

  final TopProductsRemoteDataSource _remoteDataSource;

  @override
  Future<TopProductsResponse> getTopProducts() async {
    try {
      final response = await _remoteDataSource.getTopProducts();
      return response.toEntity();
    } on NetworkException catch (e) {
      throw Exception('Ошибка сети: ${e.message}');
    } catch (e) {
      throw Exception('Неожиданная ошибка при получении популярных товаров: $e');
    }
  }
}
