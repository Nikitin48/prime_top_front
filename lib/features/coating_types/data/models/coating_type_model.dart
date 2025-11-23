import 'package:prime_top_front/core/utils/xss_protection.dart';
import 'package:prime_top_front/features/coating_types/domain/entities/coating_type.dart';

class CoatingTypeModel extends CoatingType {
  const CoatingTypeModel({
    required super.id,
    required super.name,
    required super.nomenclature,
  });

  factory CoatingTypeModel.fromJson(Map<String, dynamic> json) {
    try {
      return CoatingTypeModel(
        id: json['id'] is int ? json['id'] as int : 0,
        name: XssProtection.sanitize(json['name'] as String?),
        nomenclature: XssProtection.sanitize(json['nomenclature'] as String?),
      );
    } catch (e) {
      return const CoatingTypeModel(id: 0, name: '', nomenclature: '');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nomenclature': nomenclature,
    };
  }

  CoatingType toEntity() {
    return CoatingType(
      id: id,
      name: name,
      nomenclature: nomenclature,
    );
  }
}
