import 'package:flutter/material.dart';
import 'package:prime_top_front/core/gen/colors.gen.dart';
import 'package:prime_top_front/core/utils/ral_color_helper.dart';
import 'package:prime_top_front/features/orders/domain/entities/order_item.dart';
import 'package:intl/intl.dart';

class OrderItemsSection extends StatelessWidget {
  const OrderItemsSection({
    super.key,
    required this.items,
  });

  final List<OrderItem> items;

  String _formatDate(DateTime? date) {
    if (date == null) return '—';
    return DateFormat('dd.MM.yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(24),
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
          Text(
            'Позиции заказа (${items.length})',
            style: theme.textTheme.titleLarge?.copyWith(
              color: isDark
                  ? ColorName.darkThemeTextPrimary
                  : ColorName.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...items.map((item) => _OrderItemCard(
                item: item,
                isDark: isDark,
                theme: theme,
                formatDate: _formatDate,
              )),
        ],
      ),
    );
  }
}

class _OrderItemCard extends StatelessWidget {
  const _OrderItemCard({
    required this.item,
    required this.isDark,
    required this.theme,
    required this.formatDate,
  });

  final OrderItem item;
  final bool isDark;
  final ThemeData theme;
  final String Function(DateTime?) formatDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? ColorName.darkThemeBackgroundSecondary
            : ColorName.backgroundSecondary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark
              ? ColorName.darkThemeBorderSoft
              : ColorName.borderSoft,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: RalColorHelper.getRalColor(item.product.colorCode),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDark
                        ? ColorName.darkThemeBorderSoft
                        : ColorName.borderSoft,
                    width: 2,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.product.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: isDark
                            ? ColorName.darkThemeTextPrimary
                            : ColorName.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Тип покрытия: ${item.product.coatingType.name} (${item.product.coatingType.nomenclature})',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? ColorName.darkThemeTextSecondary
                            : ColorName.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Код цвета: ${item.product.colorCode}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? ColorName.darkThemeTextSecondary
                            : ColorName.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Цена: ${item.product.price} ₽',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark
                            ? ColorName.darkThemeTextPrimary
                            : ColorName.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark
                      ? ColorName.darkThemeCardBackground
                      : ColorName.cardBackground,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDark
                        ? ColorName.darkThemeBorderSoft
                        : ColorName.borderSoft,
                  ),
                ),
                child: Text(
                  'Количество: ${item.quantity}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: isDark
                        ? ColorName.darkThemeTextPrimary
                        : ColorName.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          if (item.series != null) ...[
            if (item.series!.name != null ||
                item.series!.productionDate != null ||
                item.series!.expireDate != null) ...[
              const SizedBox(height: 12),
              Divider(
                color: isDark
                    ? ColorName.darkThemeBorderSoft
                    : ColorName.borderSoft,
              ),
              const SizedBox(height: 12),
              Text(
                'Информация о серии',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? ColorName.darkThemeTextSecondary
                      : ColorName.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              if (item.series!.name != null)
                _SeriesInfoRow(
                  label: 'Название',
                  value: item.series!.name!,
                  isDark: isDark,
                  theme: theme,
                ),
              if (item.series!.productionDate != null) ...[
                const SizedBox(height: 4),
                _SeriesInfoRow(
                  label: 'Дата производства',
                  value: formatDate(item.series!.productionDate),
                  isDark: isDark,
                  theme: theme,
                ),
              ],
              if (item.series!.expireDate != null) ...[
                const SizedBox(height: 4),
                _SeriesInfoRow(
                  label: 'Срок годности',
                  value: formatDate(item.series!.expireDate),
                  isDark: isDark,
                  theme: theme,
                ),
              ],
            ],
          ] else ...[
            const SizedBox(height: 12),
            Divider(
              color: isDark
                  ? ColorName.darkThemeBorderSoft
                  : ColorName.borderSoft,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: ColorName.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: ColorName.primary.withOpacity(0.3),
                ),
              ),
              child: Text(
                'Данный товар будет отправлен на производство',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: ColorName.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SeriesInfoRow extends StatelessWidget {
  const _SeriesInfoRow({
    required this.label,
    required this.value,
    required this.isDark,
    required this.theme,
  });

  final String label;
  final String value;
  final bool isDark;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark
                  ? ColorName.darkThemeTextSecondary
                  : ColorName.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isDark
                  ? ColorName.darkThemeTextPrimary
                  : ColorName.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
