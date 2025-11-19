import 'package:prime_top_front/features/home/domain/entities/landing_stats.dart';
import 'package:prime_top_front/features/products/domain/entities/product.dart';

abstract class LandingRepository {
  Future<LandingStats> getLandingStats();
  Future<List<Product>> getPopularProducts();
}
