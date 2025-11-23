import 'package:prime_top_front/core/utils/xss_protection.dart';
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
    try {
      CoatingTypeModel coatingTypeModel;
      if (json.containsKey('coating_type') && json['coating_type'] != null) {
        if (json['coating_type'] is Map<String, dynamic>) {
          coatingTypeModel = CoatingTypeModel.fromJson(
            json['coating_type'] as Map<String, dynamic>,
          );
        } else {
          coatingTypeModel = const CoatingTypeModel(id: 0, name: '', nomenclature: '');
        }
      } else {
        coatingTypeModel = const CoatingTypeModel(id: 0, name: '', nomenclature: '');
      }
      
      return ProductModel(
        id: json['id'] is int ? json['id'] as int : 0,
        name: XssProtection.sanitize(json['name'] as String?),
        colorCode: json['color_code'] is int ? json['color_code'] as int : 0,
        price: json['price'] is int ? json['price'] as int : 0,
        coatingType: coatingTypeModel.toEntity(),
      );
    } catch (e) {
      return ProductModel(
        id: 0,
        name: '',
        colorCode: 0,
        price: 0,
        coatingType: const CoatingTypeModel(id: 0, name: '', nomenclature: '').toEntity(),
      );
    }
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
