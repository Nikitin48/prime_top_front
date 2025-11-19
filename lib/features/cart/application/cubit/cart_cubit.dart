import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_top_front/features/cart/application/cubit/cart_state.dart';
import 'package:prime_top_front/features/cart/domain/repositories/cart_repository.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit(this._repository) : super(const CartState());

  final CartRepository _repository;

  Future<void> loadCart() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final cart = await _repository.getCart();
      emit(state.copyWith(
        cart: cart,
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
        errorMessage: 'Ошибка загрузки корзины',
      ));
    }
  }

  Future<void> addItemToCart({
    required int productId,
    int? seriesId,
    int quantity = 1,
  }) async {
    final itemKey = seriesId != null ? '${productId}_$seriesId' : '${productId}_null';
    emit(state.copyWith(
      isAddingItem: true,
      addingItemKey: itemKey,
      errorMessage: null,
    ));

    try {
      await _repository.addItemToCart(
        productId: productId,
        seriesId: seriesId,
        quantity: quantity,
      );
      await loadCart();
      emit(state.copyWith(
        isAddingItem: false,
        addingItemKey: null,
      ));
    } on Exception catch (e) {
      emit(state.copyWith(
        isAddingItem: false,
        addingItemKey: null,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    } catch (e) {
      emit(state.copyWith(
        isAddingItem: false,
        addingItemKey: null,
        errorMessage: 'Ошибка при добавлении товара в корзину',
      ));
    }
  }

  Future<void> updateCartItemQuantity({
    required int cartItemId,
    required int quantity,
  }) async {
    try {
      await _repository.updateCartItemQuantity(
        cartItemId: cartItemId,
        quantity: quantity,
      );
      await _loadCartSilently();
    } on Exception catch (e) {
      emit(state.copyWith(
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Ошибка при обновлении количества товара',
      ));
    }
  }

  Future<void> _loadCartSilently() async {
    try {
      final cart = await _repository.getCart();
      emit(state.copyWith(
        cart: cart,
        errorMessage: null,
      ));
    } on Exception catch (e) {
      emit(state.copyWith(
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Ошибка загрузки корзины',
      ));
    }
  }

  Future<void> removeCartItem(int cartItemId) async {
    emit(state.copyWith(isRemovingItem: true, errorMessage: null));

    try {
      await _repository.removeCartItem(cartItemId);
      await loadCart();
      emit(state.copyWith(isRemovingItem: false));
    } on Exception catch (e) {
      emit(state.copyWith(
        isRemovingItem: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    } catch (e) {
      emit(state.copyWith(
        isRemovingItem: false,
        errorMessage: 'Ошибка при удалении товара из корзины',
      ));
    }
  }

  Future<void> clearCart() async {
    emit(state.copyWith(isClearing: true, errorMessage: null));

    try {
      await _repository.clearCart();
      await loadCart();
      emit(state.copyWith(isClearing: false));
    } on Exception catch (e) {
      emit(state.copyWith(
        isClearing: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
    } catch (e) {
      emit(state.copyWith(
        isClearing: false,
        errorMessage: 'Ошибка при очистке корзины',
      ));
    }
  }

  Future<int?> checkout({
    String? status,
    String? statusNote,
    String? createdAt,
    String? shippedAt,
    String? deliveredAt,
    String? cancelReason,
  }) async {
    emit(state.copyWith(isCheckingOut: true, errorMessage: null));

    try {
      final order = await _repository.checkout(
        status: status,
        statusNote: statusNote,
        createdAt: createdAt,
        shippedAt: shippedAt,
        deliveredAt: deliveredAt,
        cancelReason: cancelReason,
      );
      await loadCart();
      
      emit(state.copyWith(isCheckingOut: false));
      return order.id;
    } on Exception catch (e) {
      emit(state.copyWith(
        isCheckingOut: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
      return null;
    } catch (e) {
      emit(state.copyWith(
        isCheckingOut: false,
        errorMessage: 'Ошибка при оформлении заказа',
      ));
      return null;
    }
  }

  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }
}

