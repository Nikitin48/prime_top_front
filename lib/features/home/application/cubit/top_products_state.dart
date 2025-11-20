import 'package:equatable/equatable.dart';
import 'package:prime_top_front/features/home/domain/entities/popular_product.dart';

class TopProductsState extends Equatable {
  const TopProductsState({
    this.products = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  final List<PopularProduct> products;
  final bool isLoading;
  final String? errorMessage;

  TopProductsState copyWith({
    List<PopularProduct>? products,
    bool? isLoading,
    String? errorMessage,
  }) {
    return TopProductsState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [products, isLoading, errorMessage];
}

