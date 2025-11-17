import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_top_front/features/products/application/cubit/product_detail_state.dart';
import 'package:prime_top_front/features/products/domain/repositories/products_repository.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductDetailCubit(this._repository) : super(const ProductDetailState());

  final ProductsRepository _repository;

  Future<void> loadProductDetail(int productId) async {
    emit(state.copyWith(
      isLoading: true,
      errorMessage: null,
    ));

    try {
      final productDetail = await _repository.getProductDetail(productId);
      emit(state.copyWith(
        productDetail: productDetail,
        isLoading: false,
        errorMessage: null,
      ));
    } on Exception catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Ошибка загрузки информации о продукте',
      ));
    }
  }
}

