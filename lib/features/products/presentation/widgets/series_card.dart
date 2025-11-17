import 'package:flutter/material.dart';
import 'package:prime_top_front/core/gen/colors.gen.dart';
import 'package:prime_top_front/features/products/domain/entities/series.dart';
import 'package:prime_top_front/features/products/presentation/widgets/analyses_expansion_tile.dart';

class SeriesCard extends StatelessWidget {
  const SeriesCard({super.key, required this.series});

  final Series series;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? ColorName.darkThemeCardBackground
            : ColorName.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? ColorName.darkThemeBorderSoft
              : ColorName.borderSoft,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок серии
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  series.name ?? 'Серия #${series.id}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: isDark
                        ? ColorName.darkThemeTextPrimary
                        : ColorName.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (series.productionDate != null || series.expireDate != null) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      if (series.productionDate != null)
                        _buildDateInfo(
                          context,
                          'Дата производства',
                          series.productionDate!,
                          isDark,
                        ),
                      if (series.expireDate != null)
                        _buildDateInfo(
                          context,
                          'Срок годности',
                          series.expireDate!,
                          isDark,
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          // Характеристики (если есть)
          if (series.analyses != null)
            AnalysesExpansionTile(analyses: series.analyses!),
        ],
      ),
    );
  }

  Widget _buildDateInfo(
    BuildContext context,
    String label,
    DateTime date,
    bool isDark,
  ) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label: ',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isDark
                ? ColorName.darkThemeTextSecondary
                : ColorName.textSecondary,
          ),
        ),
        Text(
          '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isDark
                ? ColorName.darkThemeTextPrimary
                : ColorName.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

