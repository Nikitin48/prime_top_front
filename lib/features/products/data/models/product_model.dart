import 'package:prime_top_front/features/coating_types/data/models/coating_type_model.dart';
import 'package:prime_top_front/features/products/domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.colorCode,
    required super.price,
    required super.coatingType,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as int,
      name: json['name'] as String,
      colorCode: json['color_code'] as int,
      price: json['price'] as int,
      coatingType: CoatingTypeModel.fromJson(
        json['coating_type'] as Map<String, dynamic>,
      ).toEntity(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color_code': colorCode,
      'price': price,
      'coating_type': {
        'id': coatingType.id,
        'name': coatingType.name,
        'nomenclature': coatingType.nomenclature,
      },
    };
  }

  Product toEntity() {
    return Product(
      id: id,
      name: name,
      colorCode: colorCode,
      price: price,
      coatingType: coatingType,
    );
  }
}

