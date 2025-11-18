import 'package:prime_top_front/features/orders/domain/entities/order_item.dart';
import 'package:prime_top_front/features/products/data/models/product_model.dart';
import 'package:prime_top_front/features/products/data/models/series_model.dart';

class OrderItemModel extends OrderItem {
  const OrderItemModel({
    required super.id,
    required super.quantity,
    required super.product,
    required super.series,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] as int,
      quantity: json['quantity'] as int,
      product: ProductModel.fromJson(
        json['product'] as Map<String, dynamic>,
      ),
      series: SeriesModel.fromJson(
        json['series'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
      'product': (product as ProductModel).toJson(),
      'series': {
        'id': series.id,
        'name': series.name,
        'production_date': series.productionDate?.toIso8601String().split('T')[0],
        'expire_date': series.expireDate?.toIso8601String().split('T')[0],
      },
    };
  }

  OrderItem toEntity() {
    return OrderItem(
      id: id,
      quantity: quantity,
      product: (product as ProductModel).toEntity(),
      series: (series as SeriesModel).toEntity(),
    );
  }
}

