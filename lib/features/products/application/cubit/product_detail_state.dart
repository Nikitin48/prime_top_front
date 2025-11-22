import 'package:equatable/equatable.dart';
import 'package:prime_top_front/features/products/domain/entities/product_detail.dart';

class ProductDetailState extends Equatable {
  const ProductDetailState({
    this.productDetail,
    this.isLoading = false,
    this.errorMessage,
  });

  final ProductDetail? productDetail;
  final bool isLoading;
  final String? errorMessage;

  ProductDetailState copyWith({
    ProductDetail? productDetail,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ProductDetailState(
      productDetail: productDetail ?? this.productDetail,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [productDetail, isLoading, errorMessage];
}
