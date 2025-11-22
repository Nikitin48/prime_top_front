import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:prime_top_front/core/gen/colors.gen.dart';
import 'package:prime_top_front/features/orders/domain/entities/order.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.order,
    this.onTap,
  });

  final Order order;
  final VoidCallback? onTap;

  String _formatDate(DateTime? date) {
    if (date == null) return '—';
    return DateFormat('dd.MM.yyyy').format(date);
  }

  String _formatCurrency(int amount) {
    return NumberFormat.currency(
      locale: 'ru_RU',
      symbol: '₽',
      decimalDigits: 0,
    ).format(amount);
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'created':
        return 'Создан';
      case 'pending':
        return 'Ожидает подтверждения';
      case 'processing':
        return 'В производстве';
      case 'shipped':
        return 'Отгружен';
      case 'delivered':
        return 'Доставлен';
      case 'cancelled':
        return 'Отменён';
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
    final statusColor = _getStatusColor(order.status, isDark);
    final totalAmount = _formatCurrency(_calculateTotalAmount());
    final progressSteps = const ['created', 'pending', 'processing', 'shipped', 'delivered'];
    final currentStep = progressSteps.indexOf(order.status).clamp(0, progressSteps.length - 1);
    final clientBadge = order.client;
    final colorMarkers = order.items
        .map((e) => e.product.colorCode)
        .where((code) => code != 0)
        .take(4)
        .toList();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: isDark ? ColorName.darkThemeCardBackground : ColorName.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? ColorName.darkThemeBorderSoft : ColorName.borderSoft,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 18,
                  offset: const Offset(0, 14),
                  spreadRadius: -10,
                ),
              ],
      ),
      child: InkWell(
        onTap: onTap ?? () => context.goNamed('order_detail', pathParameters: {'orderId': order.id.toString()}),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Заказ #${order.id}',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: isDark ? ColorName.darkThemeTextPrimary : ColorName.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Создан ${_formatDate(order.createdAt)}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isDark ? ColorName.darkThemeTextSecondary : ColorName.textSecondary,
                          ),
                        ),
                        if (clientBadge.name.isNotEmpty || clientBadge.email.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? ColorName.darkThemeBackgroundSecondary.withOpacity(0.8)
                                  : ColorName.backgroundSecondary,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isDark ? ColorName.darkThemeBorderSoft : ColorName.borderSoft,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.person_outline,
                                  size: 16,
                                  color: isDark
                                      ? ColorName.darkThemeTextSecondary
                                      : ColorName.textSecondary,
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (clientBadge.name.isNotEmpty)
                                      Text(
                                        clientBadge.name,
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: isDark
                                              ? ColorName.darkThemeTextPrimary
                                              : ColorName.textPrimary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    if (clientBadge.email.isNotEmpty)
                                      Text(
                                        clientBadge.email,
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: isDark
                                              ? ColorName.darkThemeTextSecondary
                                              : ColorName.textSecondary,
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  _StatusBadge(label: _getStatusText(order.status), color: statusColor),
                ],
              ),
              const SizedBox(height: 14),
              const Divider(height: 20),
              if (colorMarkers.isNotEmpty) ...[
                Wrap(
                  spacing: 6,
                  children: colorMarkers
                      .map(
                        (code) => _ColorDot(
                          color: Color(code),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 12),
              ],
              _ProgressBar(
                steps: progressSteps.map(_getStatusText).toList(),
                activeIndex: currentStep,
                color: statusColor,
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _InfoItem(
                    icon: Icons.calendar_today,
                    label: 'Создан',
                    value: _formatDate(order.createdAt),
                  ),
                  if (order.shippedAt != null)
                    _InfoItem(
                      icon: Icons.local_shipping_outlined,
                      label: 'Отгружен',
                      value: _formatDate(order.shippedAt),
                    ),
                  if (order.deliveredAt != null)
                    _InfoItem(
                      icon: Icons.check_circle_outline,
                      label: 'Доставлен',
                      value: _formatDate(order.deliveredAt),
                    ),
                  _InfoItem(
                    icon: Icons.shopping_bag_outlined,
                    label: 'Позиции',
                    value: '${order.items.length}',
                  ),
                  _InfoItem(
                    icon: Icons.inventory_2_outlined,
                    label: 'Общий объём',
                    value: order.totalQuantity.toStringAsFixed(0),
                  ),
                  _InfoItem(
                    icon: Icons.payments_outlined,
                    label: 'Сумма заказа',
                    value: totalAmount,
                  ),
                ],
              ),
              if (order.cancelReason != null) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: ColorName.danger.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: ColorName.danger.withOpacity(0.35),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.cancel,
                        size: 20,
                        color: ColorName.danger,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Причина отмены: ${order.cancelReason}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: ColorName.danger,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.18),
            color.withOpacity(0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Text(
        label,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({
    required this.steps,
    required this.activeIndex,
    required this.color,
  });

  final List<String> steps;
  final int activeIndex;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(steps.length, (index) {
            final isActive = index <= activeIndex;
            final isLast = index == steps.length - 1;
            return Expanded(
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: isActive ? color : color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        height: 2,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: isActive ? color : color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 12,
          runSpacing: 6,
          children: List.generate(
            steps.length,
            (index) => Text(
              steps[index],
              style: theme.textTheme.bodySmall?.copyWith(
                color: index == activeIndex
                    ? color
                    : (theme.brightness == Brightness.dark
                        ? ColorName.darkThemeTextSecondary
                        : ColorName.textSecondary),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black.withOpacity(0.08)),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 180),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isDark
              ? ColorName.darkThemeBackgroundSecondary.withOpacity(0.8)
              : ColorName.backgroundSecondary,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark ? ColorName.darkThemeBorderSoft : ColorName.borderSoft,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isDark ? ColorName.darkThemeBorderSoft : Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 16,
                color: isDark ? ColorName.darkThemeTextSecondary : ColorName.textSecondary,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? ColorName.darkThemeTextSecondary
                          : ColorName.textSecondary,
                    ),
                  ),
                  Text(
                    value,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark
                          ? ColorName.darkThemeTextPrimary
                          : ColorName.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
