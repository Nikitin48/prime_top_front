import 'package:equatable/equatable.dart';

class DataLakeInfo extends Equatable {
  const DataLakeInfo({
    required this.supportedFormats,
    required this.supportedDataTypes,
    required this.fieldMapping,
  });

  final List<String> supportedFormats;
  final Map<String, DataTypeInfo> supportedDataTypes;
  final FieldMapping fieldMapping;

  @override
  List<Object?> get props => [supportedFormats, supportedDataTypes, fieldMapping];
}

class DataTypeInfo extends Equatable {
  const DataTypeInfo({
    required this.description,
    required this.requiredFields,
    required this.optionalFields,
  });

  final String description;
  final List<String> requiredFields;
  final List<String> optionalFields;

  @override
  List<Object?> get props => [description, requiredFields, optionalFields];
}

class FieldMapping extends Equatable {
  const FieldMapping({
    required this.note,
    required this.examples,
  });

  final String note;
  final Map<String, List<String>> examples;

  @override
  List<Object?> get props => [note, examples];
}

