import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_top_front/features/home/application/cubit/top_products_state.dart';
import 'package:prime_top_front/features/home/domain/repositories/top_products_repository.dart';

class TopProductsCubit extends Cubit<TopProductsState> {
  TopProductsCubit(this._repository) : super(const TopProductsState());

  final TopProductsRepository _repository;

  Future<void> loadTopProducts() async {
    if (state.products.isNotEmpty && !state.isLoading) {
      return;
    }

    emit(state.copyWith(
      isLoading: true,
      errorMessage: null,
    ));

    try {
      final response = await _repository.getTopProducts();
      emit(state.copyWith(
        products: response.results,
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
        errorMessage: 'Ошибка загрузки популярных товаров',
      ));
    }
  }

  void clearTopProducts() {
    emit(const TopProductsState());
  }
}

