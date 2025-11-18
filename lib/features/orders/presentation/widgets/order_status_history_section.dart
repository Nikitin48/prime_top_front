import 'package:flutter/material.dart';
import 'package:prime_top_front/core/gen/colors.gen.dart';
import 'package:prime_top_front/features/orders/domain/entities/order_status_history.dart';
import 'package:intl/intl.dart';

class OrderStatusHistorySection extends StatelessWidget {
  const OrderStatusHistorySection({
    super.key,
    required this.history,
  });

  final List<OrderStatusHistory> history;

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd.MM.yyyy HH:mm').format(dateTime);
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'created':
        return 'Создан';
      case 'pending':
        return 'В ожидании';
      case 'processing':
        return 'В обработке';
      case 'shipped':
        return 'Отправлен';
      case 'delivered':
        return 'Доставлен';
      case 'cancelled':
        return 'Отменен';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (history.isEmpty) {
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
            'История изменения статусов',
            style: theme.textTheme.titleLarge?.copyWith(
              color: isDark
                  ? ColorName.darkThemeTextPrimary
                  : ColorName.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...history.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isLast = index == history.length - 1;

            return _StatusHistoryItem(
              item: item,
              isLast: isLast,
              isDark: isDark,
              theme: theme,
              formatDateTime: _formatDateTime,
              getStatusText: _getStatusText,
            );
          }),
        ],
      ),
    );
  }
}

class _StatusHistoryItem extends StatelessWidget {
  const _StatusHistoryItem({
    required this.item,
    required this.isLast,
    required this.isDark,
    required this.theme,
    required this.formatDateTime,
    required this.getStatusText,
  });

  final OrderStatusHistory item;
  final bool isLast;
  final bool isDark;
  final ThemeData theme;
  final String Function(DateTime) formatDateTime;
  final String Function(String) getStatusText;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ColorName.primary,
                border: Border.all(
                  color: isDark
                      ? ColorName.darkThemeCardBackground
                      : ColorName.cardBackground,
                  width: 2,
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 60,
                color: isDark
                    ? ColorName.darkThemeBorderSoft
                    : ColorName.borderSoft,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      getStatusText(item.fromStatus),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark
                            ? ColorName.darkThemeTextSecondary
                            : ColorName.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward,
                      size: 16,
                      color: isDark
                          ? ColorName.darkThemeTextSecondary
                          : ColorName.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      getStatusText(item.toStatus),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark
                            ? ColorName.darkThemeTextPrimary
                            : ColorName.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  formatDateTime(item.changedAt),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? ColorName.darkThemeTextSecondary
                        : ColorName.textSecondary,
                  ),
                ),
                if (item.note != null && item.note!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.note!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? ColorName.darkThemeTextSecondary
                          : ColorName.textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

