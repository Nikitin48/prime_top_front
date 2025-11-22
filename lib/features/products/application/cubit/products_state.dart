import 'package:equatable/equatable.dart';
import 'package:prime_top_front/features/products/domain/entities/product.dart';

class ProductsState extends Equatable {
  const ProductsState({
    this.products = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.selectedCoatingTypeId,
    this.totalCount = 0,
  });

  final List<Product> products;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;
  final int? selectedCoatingTypeId;
  final int totalCount;

  ProductsState copyWith({
    List<Product>? products,
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
    int? selectedCoatingTypeId,
    int? totalCount,
  }) {
    return ProductsState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage,
      selectedCoatingTypeId: selectedCoatingTypeId ?? this.selectedCoatingTypeId,
      totalCount: totalCount ?? this.totalCount,
    );
  }

  @override
  List<Object?> get props => [products, isLoading, isLoadingMore, errorMessage, selectedCoatingTypeId, totalCount];
}

