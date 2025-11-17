import 'package:equatable/equatable.dart';
import 'package:prime_top_front/features/products/domain/entities/product.dart';

class ProductsState extends Equatable {
  const ProductsState({
    this.products = const [],
    this.isLoading = false,
    this.errorMessage,
    this.selectedCoatingTypeId,
    this.totalCount = 0,
  });

  final List<Product> products;
  final bool isLoading;
  final String? errorMessage;
  final int? selectedCoatingTypeId;
  final int totalCount;

  ProductsState copyWith({
    List<Product>? products,
    bool? isLoading,
    String? errorMessage,
    int? selectedCoatingTypeId,
    int? totalCount,
  }) {
    return ProductsState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      selectedCoatingTypeId: selectedCoatingTypeId ?? this.selectedCoatingTypeId,
      totalCount: totalCount ?? this.totalCount,
    );
  }

  @override
  List<Object?> get props => [products, isLoading, errorMessage, selectedCoatingTypeId, totalCount];
}

