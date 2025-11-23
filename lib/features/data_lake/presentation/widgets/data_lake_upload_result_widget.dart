import 'package:flutter/material.dart';
import 'package:prime_top_front/features/data_lake/domain/entities/data_lake_upload_result.dart';

class DataLakeUploadResultWidget extends StatelessWidget {
  const DataLakeUploadResultWidget({super.key, required this.result});

  final DataLakeUploadResult result;

  @override
  Widget build(BuildContext context) {
    final hasErrors = result.results.errors.isNotEmpty;
    final isSuccess = !hasErrors && result.results.processed > 0;

    return Card(
      color: isSuccess
          ? Colors.green.shade50
          : hasErrors
              ? Colors.orange.shade50
              : Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isSuccess
                      ? Icons.check_circle
                      : hasErrors
                          ? Icons.warning
                          : Icons.info,
                  color: isSuccess
                      ? Colors.green.shade700
                      : hasErrors
                          ? Colors.orange.shade700
                          : Colors.blue.shade700,
                ),
                const SizedBox(width: 8),
                Text(
                  'Результат загрузки',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: isSuccess
                            ? Colors.green.shade700
                            : hasErrors
                                ? Colors.orange.shade700
                                : Colors.blue.shade700,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Тип данных', result.dataType),
            if (result.fileName != null)
              _buildInfoRow('Имя файла', result.fileName!),
            _buildInfoRow('Всего строк', result.rowsCount.toString()),
            const Divider(height: 32),
            Text(
              'Статистика обработки',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Обработано',
                    result.results.processed.toString(),
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'Создано',
                    result.results.created.toString(),
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'Обновлено',
                    result.results.updated.toString(),
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'Ошибок',
                    result.results.errors.length.toString(),
                    Colors.red,
                  ),
                ),
              ],
            ),
            if (result.results.errors.isNotEmpty) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'Ошибки (${result.results.errors.length})',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...result.results.errors.map((error) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.circle,
                              size: 8,
                              color: Colors.red.shade700,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                error,
                                style: TextStyle(color: Colors.red.shade700),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.shade200),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color.shade700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

