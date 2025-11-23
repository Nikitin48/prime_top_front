import 'package:prime_top_front/core/network/exceptions.dart';
import '../domain/entities/top_products.dart';
import '../domain/entities/top_series.dart';
import '../domain/entities/top_coating_types.dart';
import '../domain/repositories/analytics_repository.dart';
import 'datasources/analytics_remote_data_source.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  AnalyticsRepositoryImpl(this._remoteDataSource);

  final AnalyticsRemoteDataSource _remoteDataSource;

  @override
  Future<TopProducts> getTopProducts({
    String? createdFrom,
    String? createdTo,
    int? clientId,
    int? coatingTypeId,
    int limit = 10,
  }) async {
    try {
      return await _remoteDataSource.getTopProducts(
        createdFrom: createdFrom,
        createdTo: createdTo,
        clientId: clientId,
        coatingTypeId: coatingTypeId,
        limit: limit,
      );
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw Exception('Ошибка при получении топ продуктов: $e');
    }
  }

  @override
  Future<TopSeries> getTopSeries({
    String? createdFrom,
    String? createdTo,
    int? clientId,
    int limit = 10,
  }) async {
    try {
      return await _remoteDataSource.getTopSeries(
        createdFrom: createdFrom,
        createdTo: createdTo,
        clientId: clientId,
        limit: limit,
      );
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw Exception('Ошибка при получении топ серий: $e');
    }
  }

  @override
  Future<TopCoatingTypes> getTopCoatingTypes({
    String? createdFrom,
    String? createdTo,
    int? clientId,
  }) async {
    try {
      return await _remoteDataSource.getTopCoatingTypes(
        createdFrom: createdFrom,
        createdTo: createdTo,
        clientId: clientId,
      );
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw Exception('Ошибка при получении топ типов покрытий: $e');
    }
  }
}
