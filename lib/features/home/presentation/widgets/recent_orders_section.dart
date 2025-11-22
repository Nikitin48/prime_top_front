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
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, authState) {
        if (authState.status == AuthStatus.authenticated) {
          context.read<OrdersCubit>().loadOrders(recent: 3);
        } else {
          context.read<OrdersCubit>().clearOrders();
        }
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          final isAuthenticated = authState.status == AuthStatus.authenticated;

          if (!isAuthenticated) {
            return _buildUnauthenticatedState(context, theme, isDark, isMobile);
          }

          return BlocBuilder<OrdersCubit, OrdersState>(
            builder: (context, ordersState) {
              if (ordersState.isLoading) {
                return _buildLoadingState(context, theme, isDark, isMobile);
              }

              if (ordersState.errorMessage != null) {
                return _buildErrorState(
                  context,
                  theme,
                  isDark,
                  ordersState.errorMessage!,
                  isMobile,
                );
              }

              final orders = ordersState.ordersResponse?.orders ?? [];
              if (orders.isEmpty) {
                return _buildEmptyState(context, theme, isDark, isMobile);
              }

              return _buildOrdersTable(context, theme, isDark, orders, isMobile);
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
    bool isMobile,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 80,
        vertical: isMobile ? 32 : 64,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, theme, isAuthenticated: false, isMobile: isMobile),
            SizedBox(height: isMobile ? 32 : 80),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'У вас пока нет заказов',
                    style: (isMobile ? theme.textTheme.titleLarge : theme.textTheme.headlineMedium)?.copyWith(
                      color: isDark
                          ? ColorName.darkThemeTextPrimary
                          : ColorName.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: isMobile ? 8 : 12),
                  Text(
                    'Создайте свой первый заказ и получите доступ к качественным\nпорошковым покрытиям для ваших проектов',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark
                          ? ColorName.darkThemeTextSecondary
                          : ColorName.textSecondary,
                      fontSize: isMobile ? 14 : null,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: isMobile ? 24 : 32),
                  ElevatedButton(
                    onPressed: () {
                      showDialog<void>(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) => const AuthDialog(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 24 : 32,
                        vertical: isMobile ? 12 : 16,
                      ),
                      backgroundColor: ColorName.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      'Сделать ваш первый заказ',
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 16,
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
    bool isMobile,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 32,
        vertical: isMobile ? 16 : 32,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, theme, isAuthenticated: true, isMobile: isMobile),
            SizedBox(height: isMobile ? 16 : 32),
            Center(
              child: Padding(
                padding: EdgeInsets.all(isMobile ? 32.0 : 64.0),
                child: const CircularProgressIndicator(),
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
    bool isMobile,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 80,
        vertical: isMobile ? 16 : 32,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, theme, isAuthenticated: true, isMobile: isMobile),
            SizedBox(height: isMobile ? 16 : 32),
            Center(
              child: Padding(
                padding: EdgeInsets.all(isMobile ? 32.0 : 64.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: isMobile ? 48 : 64,
                      color: ColorName.danger,
                    ),
                    SizedBox(height: isMobile ? 12 : 16),
                    Text(
                      errorMessage,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: ColorName.danger,
                        fontSize: isMobile ? 14 : null,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: isMobile ? 16 : 24),
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
    bool isMobile,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 80,
        vertical: isMobile ? 16 : 32,
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, theme, isAuthenticated: true, isMobile: isMobile),
            SizedBox(height: isMobile ? 16 : 32),
            Center(
              child: Padding(
                padding: EdgeInsets.all(isMobile ? 32.0 : 64.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: isMobile ? 48 : 64,
                      color: ColorName.textSecondary,
                    ),
                    SizedBox(height: isMobile ? 12 : 16),
                    Text(
                      'У вас пока нет заказов',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark
                            ? ColorName.darkThemeTextSecondary
                            : ColorName.textSecondary,
                        fontSize: isMobile ? 14 : null,
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
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 24 : 32,
                    vertical: isMobile ? 12 : 16,
                  ),
                  backgroundColor: ColorName.primary,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  'Посмотреть все заказы',
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 16,
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
    bool isMobile,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 80,
        vertical: isMobile ? 16 : 32,
      ).copyWith(top: isMobile ? 32 : 64),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, theme, isAuthenticated: true, isMobile: isMobile),
            SizedBox(height: isMobile ? 16 : 32),
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
                columnWidths: isMobile
                    ? const {
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(1.2),
                        2: FlexColumnWidth(1),
                        3: FlexColumnWidth(0.8),
                        4: FlexColumnWidth(0.8),
                      }
                    : const {
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(1.5),
                        2: FlexColumnWidth(1),
                        3: FlexColumnWidth(1),
                        4: FlexColumnWidth(1),
                      },
                children: [
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
                        isMobile ? '№' : '№ Заказа',
                        isMobile: isMobile,
                      ),
                      _buildTableHeaderCell(
                        context,
                        theme,
                        isDark,
                        isMobile ? 'Дата' : 'Дата создания',
                        isMobile: isMobile,
                      ),
                      _buildTableHeaderCell(
                        context,
                        theme,
                        isDark,
                        'Статус',
                        isMobile: isMobile,
                      ),
                      _buildTableHeaderCell(
                        context,
                        theme,
                        isDark,
                        isMobile ? 'Поз.' : 'Позиций',
                        isMobile: isMobile,
                      ),
                      _buildTableHeaderCell(
                        context,
                        theme,
                        isDark,
                        isMobile ? 'Кол.' : 'Количество',
                        isMobile: isMobile,
                      ),
                    ],
                  ),
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
                          isMobile: isMobile,
                        ),
                        _buildTableCell(
                          context,
                          theme,
                          isDark,
                          isMobile
                              ? DateFormat('dd.MM.yy').format(order.createdAt)
                              : DateFormat('dd.MM.yyyy').format(order.createdAt),
                          onTap: onOrderTap,
                          isMobile: isMobile,
                        ),
                        _buildTableCell(
                          context,
                          theme,
                          isDark,
                          _getStatusText(order.status),
                          statusColor: _getStatusColor(order.status, isDark),
                          onTap: onOrderTap,
                          isMobile: isMobile,
                        ),
                        _buildTableCell(
                          context,
                          theme,
                          isDark,
                          '${order.items.length}',
                          onTap: onOrderTap,
                          isMobile: isMobile,
                        ),
                        _buildTableCell(
                          context,
                          theme,
                          isDark,
                          order.totalQuantity.toStringAsFixed(0),
                          onTap: onOrderTap,
                          isMobile: isMobile,
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
    bool isMobile = false,
  }) {
    final isDark = theme.brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          child: Text(
            'Последние заказы',
            style: (isMobile ? theme.textTheme.titleLarge : theme.textTheme.displaySmall)?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        if (isAuthenticated) ...[
          SizedBox(width: isMobile ? 4 : 8),
          Flexible(
            child: TextButton(
              onPressed: () => context.goNamed('orders'),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 8 : 12,
                  vertical: isMobile ? 6 : 8,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      isMobile ? 'Все заказы' : 'Посмотреть все заказы',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark
                            ? ColorName.darkThemeTextPrimary
                            : ColorName.textPrimary,
                        fontWeight: FontWeight.w500,
                        fontSize: isMobile ? 13 : null,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(width: isMobile ? 2 : 4),
                  Icon(
                    Icons.arrow_forward,
                    size: isMobile ? 16 : 18,
                    color: isDark
                        ? ColorName.darkThemeTextPrimary
                        : ColorName.textPrimary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTableHeaderCell(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    String text, {
    bool isMobile = false,
  }) {
    return Padding(
      padding: EdgeInsets.all(isMobile ? 8 : 16),
      child: Text(
        text,
        style: theme.textTheme.titleSmall?.copyWith(
          color: isDark
              ? ColorName.darkThemeTextPrimary
              : ColorName.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: isMobile ? 12 : null,
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
    bool isMobile = false,
  }) {
    final cell = Padding(
      padding: EdgeInsets.all(isMobile ? 8 : 16),
      child: statusColor != null
          ? Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 8 : 12,
                vertical: isMobile ? 4 : 6,
              ),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: statusColor.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                text,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.w500,
                  fontSize: isMobile ? 11 : null,
                ),
              ),
            )
          : Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark
                    ? ColorName.darkThemeTextPrimary
                    : ColorName.textPrimary,
                fontSize: isMobile ? 12 : null,
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

