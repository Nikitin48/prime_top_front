import 'dart:typed_data';

import 'package:prime_top_front/core/network/exceptions.dart';
import 'package:prime_top_front/features/data_lake/data/datasources/data_lake_remote_data_source.dart';
import 'package:prime_top_front/features/data_lake/domain/entities/data_lake_info.dart';
import 'package:prime_top_front/features/data_lake/domain/entities/data_lake_upload_result.dart';
import 'package:prime_top_front/features/data_lake/domain/repositories/data_lake_repository.dart';

class DataLakeRepositoryImpl implements DataLakeRepository {
  DataLakeRepositoryImpl(this._remoteDataSource);

  final DataLakeRemoteDataSource _remoteDataSource;

  @override
  Future<DataLakeUploadResult> uploadDataLakeFile({
    required Uint8List fileBytes,
    required String fileName,
    required String dataType,
  }) async {
    try {
      final result = await _remoteDataSource.uploadDataLakeFile(
        fileBytes: fileBytes,
        fileName: fileName,
        dataType: dataType,
      );
      return result.toEntity();
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw Exception('Ошибка при загрузке файла: $e');
    }
  }

  @override
  Future<DataLakeInfo> getDataLakeInfo() async {
    try {
      final info = await _remoteDataSource.getDataLakeInfo();
      return info.toEntity();
    } on NetworkException {
      rethrow;
    } catch (e) {
      throw Exception('Ошибка при получении информации: $e');
    }
  }
}

