import 'package:prime_top_front/features/home/domain/entities/top_products_response.dart';

abstract class TopProductsRepository {
  Future<TopProductsResponse> getTopProducts();
}
