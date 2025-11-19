import 'package:equatable/equatable.dart';
import 'package:prime_top_front/features/products/domain/entities/product.dart';

class PopularProductsState extends Equatable {
  const PopularProductsState({
    this.products = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  final List<Product> products;
  final bool isLoading;
  final String? errorMessage;

  PopularProductsState copyWith({
    List<Product>? products,
    bool? isLoading,
    String? errorMessage,
  }) {
    return PopularProductsState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [products, isLoading, errorMessage];
}
