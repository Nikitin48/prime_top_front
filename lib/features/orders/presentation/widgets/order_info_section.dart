import 'package:flutter/material.dart';
import 'package:prime_top_front/core/gen/colors.gen.dart';
import 'package:prime_top_front/features/orders/domain/entities/order.dart';
import 'package:intl/intl.dart';

class OrderInfoSection extends StatelessWidget {
  const OrderInfoSection({
    super.key,
    required this.order,
  });

  final Order order;

  String _formatDate(DateTime? date) {
    if (date == null) return '—';
    return DateFormat('dd.MM.yyyy').format(date);
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

  Color _getStatusColor(String status, bool isDark) {
    switch (status) {
      case 'created':
        return isDark ? ColorName.darkThemeTextSecondary : ColorName.textSecondary;
      case 'pending':
        return ColorName.warning;
      case 'processing':
        return ColorName.primary;
      case 'shipped':
        return ColorName.secondary;
      case 'delivered':
        return ColorName.success;
      case 'cancelled':
        return ColorName.danger;
      default:
        return isDark ? ColorName.darkThemeTextSecondary : ColorName.textSecondary;
    }
  }

  int _calculateTotalAmount() {
    return order.items.fold<int>(
      0,
      (sum, item) => sum + (item.quantity * item.product.price),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Заказ #${order.id}',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: isDark
                      ? ColorName.darkThemeTextPrimary
                      : ColorName.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _getStatusColor(order.status, isDark).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _getStatusColor(order.status, isDark).withOpacity(0.3),
                  ),
                ),
                child: Text(
                  _getStatusText(order.status),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: _getStatusColor(order.status, isDark),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _InfoRow(
            label: 'Клиент',
            value: order.client.name,
            isDark: isDark,
            theme: theme,
          ),
          const SizedBox(height: 12),
          _InfoRow(
            label: 'Email',
            value: order.client.email,
            isDark: isDark,
            theme: theme,
          ),
          const SizedBox(height: 12),
          _InfoRow(
            label: 'Дата создания',
            value: _formatDate(order.createdAt),
            isDark: isDark,
            theme: theme,
          ),
          if (order.shippedAt != null) ...[
            const SizedBox(height: 12),
            _InfoRow(
              label: 'Дата отправки',
              value: _formatDate(order.shippedAt),
              isDark: isDark,
              theme: theme,
            ),
          ],
          if (order.deliveredAt != null) ...[
            const SizedBox(height: 12),
            _InfoRow(
              label: 'Дата доставки',
              value: _formatDate(order.deliveredAt),
              isDark: isDark,
              theme: theme,
            ),
          ],
          if (order.cancelReason != null) ...[
            const SizedBox(height: 12),
            _InfoRow(
              label: 'Причина отмены',
              value: order.cancelReason!,
              isDark: isDark,
              theme: theme,
            ),
          ],
          const SizedBox(height: 12),
          _InfoRow(
            label: 'Общее количество',
            value: order.totalQuantity.toStringAsFixed(0),
            isDark: isDark,
            theme: theme,
          ),
          const SizedBox(height: 12),
          _InfoRow(
            label: 'Сумма заказа',
            value: '${_calculateTotalAmount()} ₽',
            isDark: isDark,
            theme: theme,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark
                  ? ColorName.darkThemeTextSecondary
                  : ColorName.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark
                  ? ColorName.darkThemeTextPrimary
                  : ColorName.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
