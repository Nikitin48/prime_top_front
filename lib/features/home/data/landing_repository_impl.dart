import 'package:prime_top_front/core/network/exceptions.dart';
import 'package:prime_top_front/features/home/data/datasources/landing_remote_data_source.dart';
import 'package:prime_top_front/features/home/domain/entities/landing_stats.dart';
import 'package:prime_top_front/features/home/domain/repositories/landing_repository.dart';
import 'package:prime_top_front/features/products/domain/entities/product.dart';

class LandingRepositoryImpl implements LandingRepository {
  LandingRepositoryImpl(this._remoteDataSource);

  final LandingRemoteDataSource _remoteDataSource;

  @override
  Future<LandingStats> getLandingStats() async {
    try {
      return await _remoteDataSource.getLandingStats();
    } on NetworkException catch (e) {
      throw Exception('Ошибка сети: ${e.message}');
    } catch (e) {
      throw Exception('Не удалось загрузить статистику: $e');
    }
  }

  @override
  Future<List<Product>> getPopularProducts() async {
    try {
      final models = await _remoteDataSource.getPopularProducts();
      return models.map((model) => model.toEntity()).toList();
    } on NetworkException catch (e) {
      throw Exception('Ошибка сети: ${e.message}');
    } catch (e) {
      throw Exception('Не удалось загрузить популярные товары: $e');
    }
  }
}
