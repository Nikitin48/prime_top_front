import 'package:prime_top_front/features/data_lake/domain/entities/data_lake_upload_result.dart';

class DataLakeUploadResultModel extends DataLakeUploadResult {
  const DataLakeUploadResultModel({
    required super.dataType,
    required super.fileName,
    required super.rowsCount,
    required super.results,
  });

  factory DataLakeUploadResultModel.fromJson(Map<String, dynamic> json) {
    return DataLakeUploadResultModel(
      dataType: json['data_type'] as String,
      fileName: json['file_name'] as String?,
      rowsCount: json['rows_count'] as int,
      results: DataLakeUploadResultsModel.fromJson(
        json['results'] as Map<String, dynamic>,
      ),
    );
  }

  DataLakeUploadResult toEntity() {
    return DataLakeUploadResult(
      dataType: dataType,
      fileName: fileName,
      rowsCount: rowsCount,
      results: results,
    );
  }
}

class DataLakeUploadResultsModel extends DataLakeUploadResults {
  const DataLakeUploadResultsModel({
    required super.processed,
    required super.created,
    required super.updated,
    required super.errors,
  });

  factory DataLakeUploadResultsModel.fromJson(Map<String, dynamic> json) {
    return DataLakeUploadResultsModel(
      processed: json['processed'] as int,
      created: json['created'] as int,
      updated: json['updated'] as int,
      errors: (json['errors'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}

