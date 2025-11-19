import 'package:equatable/equatable.dart';
import 'package:prime_top_front/features/cart/domain/entities/cart.dart';

class CartState extends Equatable {
  const CartState({
    this.cart,
    this.isLoading = false,
    this.errorMessage,
    this.isAddingItem = false,
    this.addingItemKey,
    this.isUpdatingItem = false,
    this.isRemovingItem = false,
    this.isClearing = false,
    this.isCheckingOut = false,
  });

  final Cart? cart;
  final bool isLoading;
  final String? errorMessage;
  final bool isAddingItem;
  final String? addingItemKey; // Ключ вида "productId_seriesId" или "productId_null"
  final bool isUpdatingItem;
  final bool isRemovingItem;
  final bool isClearing;
  final bool isCheckingOut;

  CartState copyWith({
    Cart? cart,
    bool? isLoading,
    String? errorMessage,
    bool? isAddingItem,
    String? addingItemKey,
    bool? isUpdatingItem,
    bool? isRemovingItem,
    bool? isClearing,
    bool? isCheckingOut,
  }) {
    return CartState(
      cart: cart ?? this.cart,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isAddingItem: isAddingItem ?? this.isAddingItem,
      addingItemKey: addingItemKey,
      isUpdatingItem: isUpdatingItem ?? this.isUpdatingItem,
      isRemovingItem: isRemovingItem ?? this.isRemovingItem,
      isClearing: isClearing ?? this.isClearing,
      isCheckingOut: isCheckingOut ?? this.isCheckingOut,
    );
  }

  @override
  List<Object?> get props => [
        cart,
        isLoading,
        errorMessage,
        isAddingItem,
        addingItemKey,
        isUpdatingItem,
        isRemovingItem,
        isClearing,
        isCheckingOut,
      ];
}

