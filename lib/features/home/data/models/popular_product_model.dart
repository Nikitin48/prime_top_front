import 'package:prime_top_front/features/coating_types/data/models/coating_type_model.dart';
import 'package:prime_top_front/features/home/domain/entities/popular_product.dart';
import 'package:prime_top_front/features/products/domain/entities/product.dart';

class PopularProductModel extends PopularProduct {
  const PopularProductModel({
    required super.product,
    required super.totalOrdered,
  });

  factory PopularProductModel.fromJson(
    Map<String, dynamic> json,
    Map<String, dynamic> coatingTypeJson,
  ) {
    final coatingType = CoatingTypeModel.fromJson(coatingTypeJson).toEntity();
    
    return PopularProductModel(
      product: Product(
        id: json['id'] as int,
        name: json['name'] as String,
        colorCode: json['color_code'] as int,
        price: json['price'] as int,
        coatingType: coatingType,
      ),
      totalOrdered: (json['total_ordered'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': product.id,
      'name': product.name,
      'color_code': product.colorCode,
      'price': product.price,
      'total_ordered': totalOrdered,
      'coating_type': {
        'id': product.coatingType.id,
        'name': product.coatingType.name,
        'nomenclature': product.coatingType.nomenclature,
      },
    };
  }

  PopularProduct toEntity() {
    return PopularProduct(
      product: product,
      totalOrdered: totalOrdered,
    );
  }
}
