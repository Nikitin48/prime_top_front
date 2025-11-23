import '../models/top_products_model.dart';
import '../models/top_series_model.dart';
import '../models/top_coating_types_model.dart';

abstract class AnalyticsRemoteDataSource {
  Future<TopProductsModel> getTopProducts({
    String? createdFrom,
    String? createdTo,
    int? clientId,
    int? coatingTypeId,
    int limit = 10,
  });

  Future<TopSeriesModel> getTopSeries({
    String? createdFrom,
    String? createdTo,
    int? clientId,
    int limit = 10,
  });

  Future<TopCoatingTypesModel> getTopCoatingTypes({
    String? createdFrom,
    String? createdTo,
    int? clientId,
  });
}
