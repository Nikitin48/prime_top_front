import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_top_front/features/products/application/cubit/products_state.dart';
import 'package:prime_top_front/features/products/domain/repositories/products_repository.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit(this._repository) : super(const ProductsState());

  final ProductsRepository _repository;

  Future<void> loadProductsByCoatingType(int coatingTypeId, {int? limit, int? offset}) async {
    if (state.selectedCoatingTypeId == coatingTypeId && state.products.isNotEmpty && offset == null) {
      return;
    }

    emit(state.copyWith(
      isLoading: true,
      errorMessage: null,
      selectedCoatingTypeId: coatingTypeId,
    ));

    try {
      final response = await _repository.getProducts(
        coatingTypeId: coatingTypeId,
        limit: limit,
        offset: offset,
      );
      emit(state.copyWith(
        products: response.products,
        isLoading: false,
        errorMessage: null,
        totalCount: response.count,
      ));
    } on Exception catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Ошибка загрузки продуктов',
      ));
    }
  }

  void clearProducts() {
    emit(const ProductsState());
  }
}

