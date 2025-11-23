import 'dart:html' as html;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_top_front/core/gen/colors.gen.dart';
import 'package:prime_top_front/core/utils/xss_protection.dart';
import 'package:prime_top_front/features/data_lake/application/cubit/data_lake_cubit.dart';
import 'package:prime_top_front/features/data_lake/application/cubit/data_lake_state.dart';
import 'package:prime_top_front/features/data_lake/presentation/widgets/data_lake_upload_result_widget.dart';
import 'package:prime_top_front/features/data_lake/presentation/widgets/data_lake_info_widget.dart';

class DataLakePage extends StatefulWidget {
  const DataLakePage({super.key});

  @override
  State<DataLakePage> createState() => _DataLakePageState();
}

class _DataLakePageState extends State<DataLakePage> {
  html.FileUploadInputElement? _fileInput;
  String? _selectedFileName;
  String _selectedDataType = 'products';

  @override
  void initState() {
    super.initState();
    _initFileInput();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DataLakeCubit>().loadInfo();
    });
  }

  void _initFileInput() {
    _fileInput = html.FileUploadInputElement();
    _fileInput!.accept = '.json';
    _fileInput!.style.display = 'none';
    html.document.body!.append(_fileInput!);
    _fileInput!.onChange.listen((e) {
      final files = _fileInput!.files;
      if (files != null && files.isNotEmpty) {
        setState(() {
          _selectedFileName = XssProtection.validateAndSanitizeFileName(files[0].name) ?? files[0].name;
        });
      }
    });
  }

  @override
  void dispose() {
    _fileInput?.remove();
    super.dispose();
  }

  Future<void> _handleFileUpload() async {
    if (_fileInput == null) {
      _initFileInput();
    }
    final files = _fileInput!.files;
    if (files == null || files.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пожалуйста, выберите файл')),
      );
      return;
    }

    final file = files[0];
    final reader = html.FileReader();

    reader.onLoadEnd.listen((e) {
      final bytes = reader.result as Uint8List?;
      if (bytes != null) {
        final sanitizedFileName = XssProtection.validateAndSanitizeFileName(file.name) ?? file.name;
        context.read<DataLakeCubit>().uploadFile(
              fileBytes: bytes,
              fileName: sanitizedFileName,
              dataType: _selectedDataType,
            );
      }
    });

    reader.readAsArrayBuffer(file);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataLakeCubit, DataLakeState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Data Lake - Загрузка данных',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 24),
              if (state.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (state.info != null)
                DataLakeInfoWidget(info: state.info!),
              const SizedBox(height: 32),
              _buildUploadSection(context, state),
              const SizedBox(height: 32),
              if (state.uploadResult != null)
                DataLakeUploadResultWidget(result: state.uploadResult!),
              if (state.errorMessage != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade300),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red.shade700),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          XssProtection.sanitize(state.errorMessage!),
                          style: TextStyle(color: Colors.red.shade700),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => context.read<DataLakeCubit>().clearError(),
                        color: Colors.red.shade700,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildUploadSection(BuildContext context, DataLakeState state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Загрузка данных',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedDataType,
                    decoration: const InputDecoration(
                      labelText: 'Тип данных',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'products', child: Text('Продукты')),
                      DropdownMenuItem(value: 'series', child: Text('Серии')),
                      DropdownMenuItem(value: 'stocks', child: Text('Остатки')),
                      DropdownMenuItem(value: 'orders', child: Text('Заказы')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedDataType = value;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Загрузка файла',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.insert_drive_file, color: Colors.grey.shade600),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _selectedFileName ?? 'Выберите JSON файл',
                            style: TextStyle(
                              color: _selectedFileName != null
                                  ? Colors.black87
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            _fileInput?.click();
                          },
                          icon: const Icon(Icons.folder_open),
                          label: const Text('Выбрать файл'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).brightness == Brightness.dark
                                ? ColorName.darkThemePrimary
                                : ColorName.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: state.isUploading ? null : _handleFileUpload,
                  icon: state.isUploading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.upload),
                  label: const Text('Загрузить файл'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).brightness == Brightness.dark
                        ? ColorName.darkThemePrimary
                        : ColorName.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

