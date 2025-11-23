import 'package:prime_top_front/features/data_lake/domain/entities/data_lake_info.dart';

class DataLakeInfoModel extends DataLakeInfo {
  const DataLakeInfoModel({
    required super.supportedFormats,
    required super.supportedDataTypes,
    required super.fieldMapping,
  });

  factory DataLakeInfoModel.fromJson(Map<String, dynamic> json) {
    final supportedDataTypesJson =
        json['supported_data_types'] as Map<String, dynamic>;
    final supportedDataTypes = <String, DataTypeInfo>{};
    supportedDataTypesJson.forEach((key, value) {
      supportedDataTypes[key] = DataTypeInfoModel.fromJson(
        value as Map<String, dynamic>,
      );
    });

    return DataLakeInfoModel(
      supportedFormats: (json['supported_formats'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      supportedDataTypes: supportedDataTypes,
      fieldMapping: FieldMappingModel.fromJson(
        json['field_mapping'] as Map<String, dynamic>,
      ),
    );
  }

  DataLakeInfo toEntity() {
    return DataLakeInfo(
      supportedFormats: supportedFormats,
      supportedDataTypes: supportedDataTypes,
      fieldMapping: fieldMapping,
    );
  }
}

class DataTypeInfoModel extends DataTypeInfo {
  const DataTypeInfoModel({
    required super.description,
    required super.requiredFields,
    required super.optionalFields,
  });

  factory DataTypeInfoModel.fromJson(Map<String, dynamic> json) {
    return DataTypeInfoModel(
      description: json['description'] as String,
      requiredFields: (json['required_fields'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      optionalFields: (json['optional_fields'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
    );
  }
}

class FieldMappingModel extends FieldMapping {
  const FieldMappingModel({
    required super.note,
    required super.examples,
  });

  factory FieldMappingModel.fromJson(Map<String, dynamic> json) {
    final examplesJson = json['examples'] as Map<String, dynamic>?;
    final examples = <String, List<String>>{};
    examplesJson?.forEach((key, value) {
      examples[key] = (value as List<dynamic>)
          .map((e) => e.toString())
          .toList();
    });

    return FieldMappingModel(
      note: json['note'] as String? ?? '',
      examples: examples,
    );
  }
}

