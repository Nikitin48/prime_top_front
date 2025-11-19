import 'package:prime_top_front/features/cart/data/datasources/cart_remote_data_source_impl.dart';
import 'package:prime_top_front/features/cart/domain/entities/cart.dart';
import 'package:prime_top_front/features/cart/domain/entities/cart_item.dart';
import 'package:prime_top_front/features/cart/domain/repositories/cart_repository.dart';
import 'package:prime_top_front/features/orders/domain/entities/order.dart';
import 'package:prime_top_front/features/products/domain/repositories/products_repository.dart';
import 'package:prime_top_front/features/products/domain/entities/series.dart';

class CartRepositoryImpl implements CartRepository {
  CartRepositoryImpl(
    this._remoteDataSource, {
    ProductsRepository? productsRepository,
  }) : _productsRepository = productsRepository;

  final CartRemoteDataSourceImpl _remoteDataSource;
  final ProductsRepository? _productsRepository;

  @override
  Future<Cart> getCart() async {
    final cartModel = await _remoteDataSource.getCart();
    var cart = cartModel.toEntity();
    
    final productsRepo = _productsRepository;
    if (productsRepo != null && cart.items.isNotEmpty) {
      final productIdsWithSeries = cart.items
          .where((item) => item.series != null)
          .map((item) => item.product.id)
          .toSet();
      
      final productDetailsMap = <int, Map<int, Series>>{};
      await Future.wait(
        productIdsWithSeries.map((productId) async {
          try {
            final productDetail = await productsRepo.getProductDetail(productId);
            final seriesMap = <int, Series>{};
            for (final series in productDetail.series) {
              seriesMap[series.id] = series;
            }
            productDetailsMap[productId] = seriesMap;
          } catch (e) {
          }
        }),
      );
      
      final updatedItems = cart.items.map((item) {
        if (item.series != null && productDetailsMap.containsKey(item.product.id)) {
          final seriesMap = productDetailsMap[item.product.id]!;
          final updatedSeries = seriesMap[item.series!.id];
          if (updatedSeries != null) {
            return CartItem(
              id: item.id,
              quantity: item.quantity,
              product: item.product,
              series: updatedSeries,
            );
          }
        }
        return item;
      }).toList();
      
      cart = Cart(
        id: cart.id,
        client: cart.client,
        createdAt: cart.createdAt,
        updatedAt: cart.updatedAt,
        items: updatedItems,
        itemsCount: cart.itemsCount,
        totalQuantity: cart.totalQuantity,
        totalPrice: cart.totalPrice,
      );
    }
    
    return cart;
  }

  @override
  Future<CartItem> addItemToCart({
    required int productId,
    int? seriesId,
    int quantity = 1,
  }) async {
    final cartItemModel = await _remoteDataSource.addItemToCart(
      productId: productId,
      seriesId: seriesId,
      quantity: quantity,
    );
    return cartItemModel.toEntity();
  }

  @override
  Future<CartItem> updateCartItemQuantity({
    required int cartItemId,
    required int quantity,
  }) async {
    final cartItemModel = await _remoteDataSource.updateCartItemQuantity(
      cartItemId: cartItemId,
      quantity: quantity,
    );
    return cartItemModel.toEntity();
  }

  @override
  Future<void> removeCartItem(int cartItemId) async {
    await _remoteDataSource.removeCartItem(cartItemId);
  }

  @override
  Future<void> clearCart() async {
    await _remoteDataSource.clearCart();
  }

  @override
  Future<Order> checkout({
    String? status,
    String? statusNote,
    String? createdAt,
    String? shippedAt,
    String? deliveredAt,
    String? cancelReason,
  }) async {
    final orderModel = await _remoteDataSource.checkout(
      status: status,
      statusNote: statusNote,
      createdAt: createdAt,
      shippedAt: shippedAt,
      deliveredAt: deliveredAt,
      cancelReason: cancelReason,
    );
    return orderModel.toEntity();
  }
}

