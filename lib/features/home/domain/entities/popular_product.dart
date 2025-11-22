import 'package:equatable/equatable.dart';
import 'package:prime_top_front/features/products/domain/entities/product.dart';

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
