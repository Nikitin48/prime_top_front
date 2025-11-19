import 'package:equatable/equatable.dart';
import 'package:prime_top_front/features/auth/domain/entities/client.dart';
import 'package:prime_top_front/features/cart/domain/entities/cart_item.dart';

class Cart extends Equatable {
  const Cart({
    required this.id,
    required this.client,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
    required this.itemsCount,
    required this.totalQuantity,
    required this.totalPrice,
  });

  final int id;
  final Client client;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<CartItem> items;
  final int itemsCount;
  final int totalQuantity;
  final int totalPrice;

  @override
  List<Object?> get props => [
        id,
        client,
        createdAt,
        updatedAt,
        items,
        itemsCount,
        totalQuantity,
        totalPrice,
      ];
}

