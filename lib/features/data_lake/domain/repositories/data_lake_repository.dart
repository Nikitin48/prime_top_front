import 'dart:typed_data';

import 'package:prime_top_front/features/data_lake/domain/entities/data_lake_info.dart';
import 'package:prime_top_front/features/data_lake/domain/entities/data_lake_upload_result.dart';

abstract class DataLakeRepository {
  Future<DataLakeUploadResult> uploadDataLakeFile({
    required Uint8List fileBytes,
    required String fileName,
    required String dataType,
  });

  Future<DataLakeInfo> getDataLakeInfo();
}

