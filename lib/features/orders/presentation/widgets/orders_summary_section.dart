import 'package:flutter/material.dart';
import 'package:prime_top_front/core/gen/colors.gen.dart';
import 'package:prime_top_front/features/orders/domain/entities/orders_summary.dart';

class OrdersSummarySection extends StatelessWidget {
  const OrdersSummarySection({
    super.key,
    required this.summary,
  });

  final List<OrdersSummary> summary;

  String _getStatusText(String status) {
    final normalized = status.toLowerCase();
    switch (normalized) {
      case 'created':
      case 'создан':
        return 'Создан';
      case 'pending':
      case 'в ожидании':
      case 'ожидает подтверждения':
        return 'Ожидает подтверждения';
      case 'processing':
      case 'в обработке':
      case 'в производстве':
        return 'В производстве';
      case 'shipped':
      case 'отгружен':
        return 'Отгружен';
      case 'delivered':
      case 'доставлен':
      case 'доставлено':
        return 'Доставлен';
      case 'cancelled':
      case 'отменён':
      case 'отменен':
      case 'отменено':
        return 'Отменён';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status, bool isDark) {
    final normalized = status.toLowerCase();
    switch (normalized) {
      case 'created':
      case 'создан':
        return isDark ? ColorName.darkThemeTextSecondary : ColorName.textSecondary;
      case 'pending':
      case 'в ожидании':
      case 'ожидает подтверждения':
        return ColorName.warning;
      case 'processing':
      case 'в обработке':
      case 'в производстве':
        return ColorName.primary;
      case 'shipped':
      case 'отгружен':
        return ColorName.secondary;
      case 'delivered':
      case 'доставлен':
      case 'доставлено':
        return ColorName.success;
      case 'cancelled':
      case 'отменён':
      case 'отменен':
      case 'отменено':
        return ColorName.danger;
      default:
        return isDark ? ColorName.darkThemeTextSecondary : ColorName.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (summary.isEmpty) {
      return const SizedBox.shrink();
    }

    final itemsWithQuantity = summary.where((item) => item.totalQuantity > 0).toList();

    if (itemsWithQuantity.isEmpty) {
      return const SizedBox.shrink();
    }

    final cards = itemsWithQuantity.map((item) {
      final statusColor = _getStatusColor(item.status, isDark);
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? ColorName.darkThemeCardBackground : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? ColorName.darkThemeBorderSoft : ColorName.borderSoft,
          ),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 10),
                    spreadRadius: -6,
                  ),
                ],
        ),
        child: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getStatusText(item.status),
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _Tag(text: 'Заказов: ${item.ordersCount}'),
                      const SizedBox(width: 8),
                      _Tag(text: 'Серий: ${item.seriesCount}'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Общий объём: ${item.totalQuantity.toStringAsFixed(0)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark ? ColorName.darkThemeTextSecondary : ColorName.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.trending_up,
              color: isDark ? ColorName.darkThemeTextSecondary : ColorName.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Сводка по статусам',
              style: theme.textTheme.titleMedium?.copyWith(
                color: isDark ? ColorName.darkThemeTextPrimary : ColorName.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...List.generate(cards.length * 2 - 1, (index) {
          if (index.isOdd) {
            return const SizedBox(height: 12);
          }
          return cards[index ~/ 2];
        }),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? ColorName.darkThemeBackgroundSecondary : ColorName.backgroundSecondary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          color: isDark ? ColorName.darkThemeTextSecondary : ColorName.textSecondary,
        ),
      ),
    );
  }
}
