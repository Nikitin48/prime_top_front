import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_top_front/core/storage/landing_cache_service.dart';
import 'package:prime_top_front/features/home/application/cubit/popular_products_state.dart';
import 'package:prime_top_front/features/home/domain/repositories/landing_repository.dart';
import 'package:prime_top_front/features/products/domain/entities/product.dart';

class PopularProductsCubit extends Cubit<PopularProductsState> {
  PopularProductsCubit(
    this._repository,
    this._cacheService,
  ) : super(const PopularProductsState());

  final LandingRepository _repository;
  final LandingCacheService _cacheService;

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final items = await _repository.getPopularProducts();
      await _cacheService.savePopularProducts(items);
      emit(
        state.copyWith(products: items, isLoading: false, errorMessage: null),
      );
    } on Exception {
      final cached = await _cacheService.loadPopularProducts();
      if (cached.isNotEmpty) {
        emit(
          state.copyWith(products: cached, isLoading: false, errorMessage: null),
        );
        return;
      }
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'Не удалось загрузить популярные товары. Попробуйте позже.',
        ),
      );
    }
  }
}
