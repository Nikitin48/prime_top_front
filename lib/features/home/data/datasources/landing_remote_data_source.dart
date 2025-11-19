import 'package:prime_top_front/features/home/data/models/landing_stats_model.dart';
import 'package:prime_top_front/features/products/data/models/product_model.dart';

abstract class LandingRemoteDataSource {
  Future<LandingStatsModel> getLandingStats();
  Future<List<ProductModel>> getPopularProducts();
}
