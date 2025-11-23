import 'dart:typed_data';

import 'package:prime_top_front/features/data_lake/data/models/data_lake_info_model.dart';
import 'package:prime_top_front/features/data_lake/data/models/data_lake_upload_result_model.dart';

abstract class DataLakeRemoteDataSource {
  Future<DataLakeUploadResultModel> uploadDataLakeFile({
    required Uint8List fileBytes,
    required String fileName,
    required String dataType,
  });

  Future<DataLakeInfoModel> getDataLakeInfo();
}

