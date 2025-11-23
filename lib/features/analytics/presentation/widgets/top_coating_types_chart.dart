import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../domain/entities/top_coating_types.dart';

class TopCoatingTypesChart extends StatelessWidget {
  const TopCoatingTypesChart({
    super.key,
    required this.data,
  });

  final TopCoatingTypes data;

  @override
  Widget build(BuildContext context) {
    if (data.coatingTypesBreakdown.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'Нет данных для отображения',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Распределение по типам покрытий',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 300,
              child: PieChart(
                _buildChartData(),
              ),
            ),
            const SizedBox(height: 16),
            _buildSummary(),
          ],
        ),
      ),
    );
  }

  PieChartData _buildChartData() {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.amber,
    ];

    return PieChartData(
      sections: data.coatingTypesBreakdown.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;
        return PieChartSectionData(
          value: item.percentageOfTotal,
          title: '${item.percentageOfTotal.toStringAsFixed(1)}%',
          color: colors[index % colors.length],
          radius: 100,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        );
      }).toList(),
      sectionsSpace: 2,
      centerSpaceRadius: 40,
    );
  }

  Widget _buildSummary() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildSummaryItem(
              'Общее количество',
              data.total.quantity.toStringAsFixed(1),
            ),
            _buildSummaryItem(
              'Общая выручка',
              data.total.revenue.toStringAsFixed(2),
            ),
            _buildSummaryItem(
              'Заказов',
              data.total.ordersCount.toString(),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: data.coatingTypesBreakdown.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final colors = [
              Colors.blue,
              Colors.green,
              Colors.orange,
              Colors.red,
              Colors.purple,
              Colors.teal,
              Colors.pink,
              Colors.amber,
            ];
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 16,
                  height: 16,
                  color: colors[index % colors.length],
                ),
                const SizedBox(width: 4),
                Text(
                  '${item.coatingTypeName} (${item.percentageOfTotal.toStringAsFixed(1)}%)',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}

