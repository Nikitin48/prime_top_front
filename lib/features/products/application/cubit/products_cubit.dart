import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_top_front/features/products/application/cubit/products_state.dart';
import 'package:prime_top_front/features/products/domain/repositories/products_repository.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit(this._repository) : super(const ProductsState());

  final ProductsRepository _repository;

  Future<void> loadProductsByCoatingType(int coatingTypeId, {int? limit, int? offset}) async {
    // Если это другой тип покрытия или offset указан явно, всегда загружаем
    // Если offset == null и это тот же тип покрытия с товарами, не загружаем повторно
    if (state.selectedCoatingTypeId == coatingTypeId && 
        state.products.isNotEmpty && 
        offset == null) {
      return;
    }

    emit(state.copyWith(
      isLoading: true,
      isLoadingMore: false,
      errorMessage: null,
      selectedCoatingTypeId: coatingTypeId,
    ));

    try {
      final response = await _repository.getProducts(
        coatingTypeId: coatingTypeId,
        limit: limit ?? 20, // По умолчанию 20 товаров
        offset: offset ?? 0,
      );
      emit(state.copyWith(
        products: response.products,
        isLoading: false,
        isLoadingMore: false,
        errorMessage: null,
        totalCount: response.count,
      ));
    } on Exception catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        errorMessage: 'Ошибка загрузки продуктов',
      ));
    }
  }

  Future<void> loadMoreProductsByCoatingType(int coatingTypeId, {int limit = 20, int offset = 0}) async {
    if (state.isLoadingMore) return;
    if (state.selectedCoatingTypeId != coatingTypeId) {
      // Если это другой тип покрытия, загружаем с начала
      await loadProductsByCoatingType(coatingTypeId, limit: limit, offset: offset);
      return;
    }

    // Если уже загружены все продукты, не загружаем еще
    if (state.products.length >= state.totalCount) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true, errorMessage: null));

    try {
      final response = await _repository.getProducts(
        coatingTypeId: coatingTypeId,
        limit: limit,
        offset: offset,
      );
      
      // Добавляем новые продукты к существующим
      final updatedProducts = [...state.products, ...response.products];
      
      emit(state.copyWith(
        products: updatedProducts,
        isLoadingMore: false,
        errorMessage: null,
        totalCount: response.count,
      ));
    } on Exception catch (e) {
      emit(state.copyWith(
        isLoadingMore: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingMore: false,
        errorMessage: 'Ошибка загрузки продуктов',
      ));
    }
  }

  void clearProducts() {
    emit(const ProductsState());
  }
}

