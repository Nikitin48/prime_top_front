import 'package:prime_top_front/features/cart/domain/entities/cart_item.dart';
import 'package:prime_top_front/features/products/data/models/product_model.dart';
import 'package:prime_top_front/features/products/data/models/series_model.dart';

class CartItemModel extends CartItem {
  const CartItemModel({
    required super.id,
    required super.quantity,
    required super.product,
    super.series,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] as int,
      quantity: json['quantity'] as int,
      product: ProductModel.fromJson(
        json['product'] as Map<String, dynamic>,
      ),
      series: json['series'] != null
          ? SeriesModel.fromJson(
              json['series'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
      'product': (product as ProductModel).toJson(),
      if (series != null)
        'series': {
          'id': series!.id,
          'name': series!.name,
          'production_date': series!.productionDate?.toIso8601String().split('T')[0],
          'expire_date': series!.expireDate?.toIso8601String().split('T')[0],
        },
    };
  }

  CartItem toEntity() {
    return CartItem(
      id: id,
      quantity: quantity,
      product: (product as ProductModel).toEntity(),
      series: series != null ? (series as SeriesModel).toEntity() : null,
    );
  }
}
