import 'package:prime_top_front/features/home/data/models/top_products_response_model.dart';

abstract class TopProductsRemoteDataSource {
  Future<TopProductsResponseModel> getTopProducts();
}

