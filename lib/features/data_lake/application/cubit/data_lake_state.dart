import 'package:equatable/equatable.dart';
import 'package:prime_top_front/features/data_lake/domain/entities/data_lake_info.dart';
import 'package:prime_top_front/features/data_lake/domain/entities/data_lake_upload_result.dart';

class DataLakeState extends Equatable {
  const DataLakeState({
    this.info,
    this.uploadResult,
    this.isLoading = false,
    this.isUploading = false,
    this.errorMessage,
  });

  final DataLakeInfo? info;
  final DataLakeUploadResult? uploadResult;
  final bool isLoading;
  final bool isUploading;
  final String? errorMessage;

  DataLakeState copyWith({
    DataLakeInfo? info,
    DataLakeUploadResult? uploadResult,
    bool? isLoading,
    bool? isUploading,
    String? errorMessage,
    bool clearError = false,
    bool clearResult = false,
  }) {
    return DataLakeState(
      info: info ?? this.info,
      uploadResult: clearResult ? null : (uploadResult ?? this.uploadResult),
      isLoading: isLoading ?? this.isLoading,
      isUploading: isUploading ?? this.isUploading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [info, uploadResult, isLoading, isUploading, errorMessage];
}

