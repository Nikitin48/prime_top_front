import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_top_front/core/network/exceptions.dart';
import 'package:prime_top_front/features/data_lake/application/cubit/data_lake_state.dart';
import 'package:prime_top_front/features/data_lake/domain/repositories/data_lake_repository.dart';

class DataLakeCubit extends Cubit<DataLakeState> {
  DataLakeCubit(this._repository) : super(const DataLakeState());

  final DataLakeRepository _repository;

  Future<void> loadInfo() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final info = await _repository.getDataLakeInfo();
      emit(state.copyWith(info: info, isLoading: false));
    } on UnauthorizedException catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Ошибка авторизации: ${e.message}',
      ));
    } on NetworkException catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Ошибка сети: ${e.message}',
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'Ошибка при загрузке информации: $e',
      ));
    }
  }

  Future<void> uploadFile({
    required Uint8List fileBytes,
    required String fileName,
    required String dataType,
  }) async {
    emit(state.copyWith(isUploading: true, clearError: true, clearResult: true));
    try {
      final result = await _repository.uploadDataLakeFile(
        fileBytes: fileBytes,
        fileName: fileName,
        dataType: dataType,
      );
      emit(state.copyWith(
        uploadResult: result,
        isUploading: false,
      ));
    } on UnauthorizedException catch (e) {
      emit(state.copyWith(
        isUploading: false,
        errorMessage: 'Ошибка авторизации: ${e.message}',
      ));
    } on NetworkException catch (e) {
      emit(state.copyWith(
        isUploading: false,
        errorMessage: 'Ошибка сети: ${e.message}',
      ));
    } catch (e) {
      emit(state.copyWith(
        isUploading: false,
        errorMessage: 'Ошибка при загрузке файла: $e',
      ));
    }
  }

  void clearResult() {
    emit(state.copyWith(clearResult: true));
  }

  void clearError() {
    emit(state.copyWith(clearError: true));
  }
}

