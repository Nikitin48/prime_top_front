import 'package:prime_top_front/features/cart/domain/entities/cart.dart';
import 'package:prime_top_front/features/cart/domain/entities/cart_item.dart';
import 'package:prime_top_front/features/orders/domain/entities/order.dart';

abstract class CartRepository {
  Future<Cart> getCart();

  Future<CartItem> addItemToCart({
    required int productId,
    int? seriesId,
    int quantity = 1,
  });

  Future<CartItem> updateCartItemQuantity({
    required int cartItemId,
    required int quantity,
  });

  Future<void> removeCartItem(int cartItemId);

  Future<void> clearCart();

  Future<Order> checkout({
    String? status,
    String? statusNote,
    String? createdAt,
    String? shippedAt,
    String? deliveredAt,
    String? cancelReason,
  });
}
