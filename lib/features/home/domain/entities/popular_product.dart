import 'package:equatable/equatable.dart';
import 'package:prime_top_front/features/products/domain/entities/product.dart';

/// Популярный товар с информацией о количестве заказанных единиц
class PopularProduct extends Equatable {
  const PopularProduct({
    required this.product,
    required this.totalOrdered,
  });

  final Product product;
  final double totalOrdered;

  @override
  List<Object?> get props => [product, totalOrdered];
}

