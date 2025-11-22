import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_top_front/features/products/application/cubit/products_state.dart';
import 'package:prime_top_front/features/products/domain/repositories/products_repository.dart';

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit(this._repository) : super(const ProductsState());

  final ProductsRepository _repository;

  Future<void> loadProductsByCoatingType(int coatingTypeId, {int? limit, int? offset}) async {
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
      searchQuery: null,
    ));

    try {
      final response = await _repository.getProducts(
        coatingTypeId: coatingTypeId,
        limit: limit ?? 20,
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
      await loadProductsByCoatingType(coatingTypeId, limit: limit, offset: offset);
      return;
    }

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

  Future<void> searchProducts(String query, {int? limit, int? offset}) async {
    if (state.searchQuery == query && 
        state.products.isNotEmpty && 
        offset == null) {
      return;
    }

    emit(state.copyWith(
      isLoading: true,
      isLoadingMore: false,
      errorMessage: null,
      searchQuery: query,
      selectedCoatingTypeId: null,
    ));

    try {
      final response = await _repository.searchProducts(
        query: query,
        limit: limit ?? 20,
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
        errorMessage: 'Ошибка поиска продуктов',
      ));
    }
  }

  Future<void> loadMoreSearchResults(String query, {int limit = 20, int offset = 0}) async {
    if (state.isLoadingMore) return;
    if (state.searchQuery != query) {
      await searchProducts(query, limit: limit, offset: offset);
      return;
    }

    if (state.products.length >= state.totalCount) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true, errorMessage: null));

    try {
      final response = await _repository.searchProducts(
        query: query,
        limit: limit,
        offset: offset,
      );
      
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
