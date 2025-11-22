import 'package:prime_top_front/features/cart/data/models/cart_item_model.dart';
import 'package:prime_top_front/features/cart/data/models/cart_model.dart';
import 'package:prime_top_front/features/orders/data/models/order_model.dart';

abstract class CartRemoteDataSource {
  Future<CartModel> getCart();

  Future<CartItemModel> addItemToCart({
    required int productId,
    int? seriesId,
    int quantity = 1,
  });

  Future<CartItemModel> updateCartItemQuantity({
    required int cartItemId,
    required int quantity,
  });

  Future<void> removeCartItem(int cartItemId);

  Future<void> clearCart();

  Future<OrderModel> checkout({
    String? status,
    String? statusNote,
    String? createdAt,
    String? shippedAt,
    String? deliveredAt,
    String? cancelReason,
  });
}
