import '../entities/top_products.dart';
import '../entities/top_series.dart';
import '../entities/top_coating_types.dart';

abstract class AnalyticsRepository {
  Future<TopProducts> getTopProducts({
    String? createdFrom,
    String? createdTo,
    int? clientId,
    int? coatingTypeId,
    int limit = 10,
  });

  Future<TopSeries> getTopSeries({
    String? createdFrom,
    String? createdTo,
    int? clientId,
    int limit = 10,
  });

  Future<TopCoatingTypes> getTopCoatingTypes({
    String? createdFrom,
    String? createdTo,
    int? clientId,
  });
}
