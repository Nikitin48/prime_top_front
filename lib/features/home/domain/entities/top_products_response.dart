import 'package:equatable/equatable.dart';
import 'package:prime_top_front/features/home/domain/entities/popular_product.dart';

/// Ответ API с ТОП 20 популярными товарами
class TopProductsResponse extends Equatable {
  const TopProductsResponse({
    required this.count,
    required this.results,
  });

  final int count;
  final List<PopularProduct> results;

  @override
  List<Object?> get props => [count, results];
}

