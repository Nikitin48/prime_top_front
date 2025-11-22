import 'package:equatable/equatable.dart';
import 'package:prime_top_front/features/products/domain/entities/product.dart';
import 'package:prime_top_front/features/products/domain/entities/series.dart';

class OrderItem extends Equatable {
  const OrderItem({
    required this.id,
    required this.quantity,
    required this.product,
    this.series,
  });

  final int id;
  final int quantity;
  final Product product;
  final Series? series;

  @override
  List<Object?> get props => [id, quantity, product, series];
}
