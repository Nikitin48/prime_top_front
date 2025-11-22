import 'package:prime_top_front/features/auth/data/models/client_model.dart';
import 'package:prime_top_front/features/cart/data/models/cart_item_model.dart';
import 'package:prime_top_front/features/cart/domain/entities/cart.dart';

class CartModel extends Cart {
  const CartModel({
    required super.id,
    required super.client,
    required super.createdAt,
    required super.updatedAt,
    required super.items,
    required super.itemsCount,
    required super.totalQuantity,
    required super.totalPrice,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    DateTime parseDateTime(String dateString) {
      try {
        return DateTime.parse(dateString);
      } catch (_) {
        throw FormatException('Неверный формат даты: $dateString');
      }
    }

    return CartModel(
      id: json['id'] as int,
      client: ClientModel.fromJson(
        json['client'] as Map<String, dynamic>,
      ),
      createdAt: parseDateTime(json['created_at'] as String),
      updatedAt: parseDateTime(json['updated_at'] as String),
      items: (json['items'] as List<dynamic>)
          .map((item) => CartItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      itemsCount: json['items_count'] as int,
      totalQuantity: json['total_quantity'] as int,
      totalPrice: json['total_price'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'client': (client as ClientModel).toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'items': items
          .map((item) => (item as CartItemModel).toJson())
          .toList(),
      'items_count': itemsCount,
      'total_quantity': totalQuantity,
      'total_price': totalPrice,
    };
  }

  Cart toEntity() {
    return Cart(
      id: id,
      client: client,
      createdAt: createdAt,
      updatedAt: updatedAt,
      items: items.map((item) => (item as CartItemModel).toEntity()).toList(),
      itemsCount: itemsCount,
      totalQuantity: totalQuantity,
      totalPrice: totalPrice,
    );
  }
}
