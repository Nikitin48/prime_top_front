import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:prime_top_front/core/gen/colors.gen.dart';
import 'package:prime_top_front/features/auth/application/cubit/auth_cubit.dart';
import 'package:prime_top_front/features/auth/presentation/widgets/auth_dialog.dart';
import 'package:prime_top_front/features/orders/application/cubit/orders_cubit.dart';
import 'package:prime_top_front/features/orders/application/cubit/orders_state.dart';
import 'package:prime_top_front/features/orders/domain/entities/order.dart';

class RecentOrdersSection extends StatefulWidget {
  const RecentOrdersSection({super.key});

  @override
  State<RecentOrdersSection> createState() => _RecentOrdersSectionState();
}

class _RecentOrdersSectionState extends State<RecentOrdersSection> {
  @override
  void initState() {
    super.initState();
    // Загружаем последние заказы при инициализации, если пользователь уже авторизован
    final authState = context.read<AuthCubit>().state;
    if (authState.status == AuthStatus.authenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<OrdersCubit>().loadOrders(recent: 3);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, authState) {
        // Загружаем заказы при авторизации
        if (authState.status == AuthStatus.authenticated) {
          context.read<OrdersCubit>().loadOrders(recent: 3);
        } else {
          // Очищаем заказы при выходе
          context.read<OrdersCubit>().clearOrders();
        }
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          final isAuthenticated = authState.status == AuthStatus.authenticated;

          if (!isAuthenticated) {
            return _buildUnauthenticatedState(context, theme, isDark);
          }

          return BlocBuilder<OrdersCubit, OrdersState>(
            builder: (context, ordersState) {
              if (ordersState.isLoading) {
                return _buildLoadingState(context, theme, isDark);
              }

              if (ordersState.errorMessage != null) {
                return _buildErrorState(
                  context,
                  theme,
                  isDark,
                  ordersState.errorMessage!,
                );
              }

              final orders = ordersState.ordersResponse?.orders ?? [];
              if (orders.isEmpty) {
                return _buildEmptyState(context, theme, isDark);
              }

              return _buildOrdersTable(context, theme, isDark, orders);
            },
          );
        },
      ),
    );
  }

  Widget _buildUnauthenticatedState(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 64),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, theme, isAuthenticated: false),
            const SizedBox(height: 80),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'У вас пока нет заказов',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: isDark
                          ? ColorName.darkThemeTextPrimary
                          : ColorName.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Создайте свой первый заказ и получите доступ к качественным\nпорошковым покрытиям для ваших проектов',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: isDark
                          ? ColorName.darkThemeTextSecondary
                          : ColorName.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      showDialog<void>(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) => const AuthDialog(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      backgroundColor: ColorName.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Сделать ваш первый заказ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
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

  Widget _buildLoadingState(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, theme, isAuthenticated: true),
            const SizedBox(height: 32),
            const Center(
              child: Padding(
                padding: EdgeInsets.all(64.0),
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    String errorMessage,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 32),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, theme, isAuthenticated: true),
            const SizedBox(height: 32),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(64.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: ColorName.danger,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      errorMessage,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: ColorName.danger,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        context.read<OrdersCubit>().loadOrders(recent: 3);
                      },
                      child: const Text('Повторить'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 32),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, theme, isAuthenticated: true),
            const SizedBox(height: 32),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(64.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 64,
                      color: ColorName.textSecondary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'У вас пока нет заказов',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: isDark
                            ? ColorName.darkThemeTextSecondary
                            : ColorName.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
           
            Center(
              child: ElevatedButton(
                onPressed: () => context.goNamed('orders'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  backgroundColor: ColorName.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Посмотреть все заказы',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersTable(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    List<Order> orders,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 32).copyWith(top: 64),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, theme, isAuthenticated: true),
            const SizedBox(height: 32),
            Container(
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
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(1.5),
                  2: FlexColumnWidth(1),
                  3: FlexColumnWidth(1),
                  4: FlexColumnWidth(1),
                },
                children: [
                  // Заголовок таблицы
                  TableRow(
                    decoration: BoxDecoration(
                      color: isDark
                          ? ColorName.darkThemeBackgroundSecondary
                          : ColorName.backgroundSecondary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    children: [
                      _buildTableHeaderCell(
                        context,
                        theme,
                        isDark,
                        '№ Заказа',
                      ),
                      _buildTableHeaderCell(
                        context,
                        theme,
                        isDark,
                        'Дата создания',
                      ),
                      _buildTableHeaderCell(
                        context,
                        theme,
                        isDark,
                        'Статус',
                      ),
                      _buildTableHeaderCell(
                        context,
                        theme,
                        isDark,
                        'Позиций',
                      ),
                      _buildTableHeaderCell(
                        context,
                        theme,
                        isDark,
                        'Количество',
                      ),
                    ],
                  ),
                  // Данные заказов
                  ...orders.asMap().entries.map((entry) {
                    final index = entry.key;
                    final order = entry.value;
                    final isLast = index == orders.length - 1;
                    
                    void onOrderTap() {
                      context.goNamed(
                        'order_detail',
                        pathParameters: {'orderId': order.id.toString()},
                      );
                    }

                    return TableRow(
                      decoration: BoxDecoration(
                        border: isLast
                            ? null
                            : Border(
                                bottom: BorderSide(
                                  color: isDark
                                      ? ColorName.darkThemeBorderSoft
                                      : ColorName.borderSoft,
                                  width: 1,
                                ),
                              ),
                      ),
                      children: [
                        _buildTableCell(
                          context,
                          theme,
                          isDark,
                          '#${order.id}',
                          onTap: onOrderTap,
                        ),
                        _buildTableCell(
                          context,
                          theme,
                          isDark,
                          DateFormat('dd.MM.yyyy').format(order.createdAt),
                          onTap: onOrderTap,
                        ),
                        _buildTableCell(
                          context,
                          theme,
                          isDark,
                          _getStatusText(order.status),
                          statusColor: _getStatusColor(order.status, isDark),
                          onTap: onOrderTap,
                        ),
                        _buildTableCell(
                          context,
                          theme,
                          isDark,
                          '${order.items.length}',
                          onTap: onOrderTap,
                        ),
                        _buildTableCell(
                          context,
                          theme,
                          isDark,
                          order.totalQuantity.toStringAsFixed(0),
                          onTap: onOrderTap,
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    ThemeData theme, {
    bool isAuthenticated = false,
  }) {
    final isDark = theme.brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Последние заказы',
          style: theme.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        if (isAuthenticated)
          TextButton(
            onPressed: () => context.goNamed('orders'),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Посмотреть все заказы',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: isDark
                        ? ColorName.darkThemeTextPrimary
                        : ColorName.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward,
                  size: 20,
                  color: isDark
                      ? ColorName.darkThemeTextPrimary
                      : ColorName.textPrimary,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildTableHeaderCell(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    String text,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        text,
        style: theme.textTheme.titleMedium?.copyWith(
          color: isDark
              ? ColorName.darkThemeTextPrimary
              : ColorName.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildTableCell(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    String text, {
    Color? statusColor,
    VoidCallback? onTap,
  }) {
    final cell = Padding(
      padding: const EdgeInsets.all(16),
      child: statusColor != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: statusColor.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                text,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          : Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? ColorName.darkThemeTextPrimary
                    : ColorName.textPrimary,
              ),
            ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        child: cell,
      );
    }

    return cell;
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
        return isDark
            ? ColorName.darkThemeTextSecondary
            : ColorName.textSecondary;
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
        return isDark
            ? ColorName.darkThemeTextSecondary
            : ColorName.textSecondary;
    }
  }
}

