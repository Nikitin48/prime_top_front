import 'package:equatable/equatable.dart';

class DataLakeUploadResult extends Equatable {
  const DataLakeUploadResult({
    required this.dataType,
    required this.fileName,
    required this.rowsCount,
    required this.results,
  });

  final String dataType;
  final String? fileName;
  final int rowsCount;
  final DataLakeUploadResults results;

  @override
  List<Object?> get props => [dataType, fileName, rowsCount, results];
}

class DataLakeUploadResults extends Equatable {
  const DataLakeUploadResults({
    required this.processed,
    required this.created,
    required this.updated,
    required this.errors,
  });

  final int processed;
  final int created;
  final int updated;
  final List<String> errors;

  @override
  List<Object?> get props => [processed, created, updated, errors];
}

