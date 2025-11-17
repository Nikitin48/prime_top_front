import 'package:prime_top_front/features/coating_types/domain/entities/coating_type.dart';

class CoatingTypeModel extends CoatingType {
  const CoatingTypeModel({
    required super.id,
    required super.name,
    required super.nomenclature,
  });

  factory CoatingTypeModel.fromJson(Map<String, dynamic> json) {
    return CoatingTypeModel(
      id: json['id'] as int,
      name: json['name'] as String,
      nomenclature: json['nomenclature'] as String,
    );
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

