import 'package:flutter/material.dart';
import 'package:prime_top_front/features/data_lake/domain/entities/data_lake_info.dart';

class DataLakeInfoWidget extends StatelessWidget {
  const DataLakeInfoWidget({super.key, required this.info});

  final DataLakeInfo info;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Поддерживаемые форматы',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: info.supportedFormats
                  .map((format) => Chip(label: Text(format)))
                  .toList(),
            ),
            const SizedBox(height: 24),
            Text(
              'Типы данных',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ...info.supportedDataTypes.entries.map((entry) {
              final dataType = entry.key;
              final typeInfo = entry.value;
              return ExpansionTile(
                title: Text(
                  dataType,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(typeInfo.description),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (typeInfo.requiredFields.isNotEmpty) ...[
                          const Text(
                            'Обязательные поля:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: typeInfo.requiredFields
                                .map((field) => Chip(
                                      label: Text(field),
                                      backgroundColor: Colors.red.shade50,
                                      labelStyle: TextStyle(
                                        color: Colors.red.shade700,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ))
                                .toList(),
                          ),
                          const SizedBox(height: 16),
                        ],
                        if (typeInfo.optionalFields.isNotEmpty) ...[
                          const Text(
                            'Опциональные поля:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: typeInfo.optionalFields
                                .map((field) => Chip(
                                      label: Text(field),
                                      backgroundColor: Colors.grey.shade100,
                                    ))
                                .toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

