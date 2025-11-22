import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_top_front/core/gen/colors.gen.dart';
import 'package:prime_top_front/core/widgets/screen_wrapper.dart';
import 'package:prime_top_front/features/orders/application/cubit/orders_cubit.dart';
import 'package:prime_top_front/features/orders/application/cubit/orders_state.dart';
import 'package:prime_top_front/features/orders/domain/entities/order.dart';
import 'package:prime_top_front/features/orders/domain/entities/orders_response.dart';
import 'package:prime_top_front/features/orders/presentation/widgets/order_card.dart';
import 'package:prime_top_front/features/orders/presentation/widgets/orders_summary_section.dart';

bool _isDelivered(String status) {
  final normalized = status.toLowerCase();
  return normalized == 'delivered' || normalized == 'доставлено' || normalized == 'доставлен';
}

bool _isCancelled(String status) {
  final normalized = status.toLowerCase();
  return normalized == 'cancelled' || normalized == 'canceled' || normalized == 'отменено' || normalized == 'отменен';
}

List<Order> _filterOrdersByTab(List<Order> orders, String tab) {
  switch (tab) {
    case 'all':
      return orders;
    case 'history':
      return orders.where((o) => _isDelivered(o.status)).toList();
    case 'cancelled':
      return orders.where((o) => _isCancelled(o.status)).toList();
    default:
      return orders.where((o) => !_isDelivered(o.status) && !_isCancelled(o.status)).toList();
  }
}

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<OrdersCubit>().loadOrders(limit: 9999, offset: 0);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _MyOrdersView(scrollController: _scrollController);
  }
}

class _MyOrdersView extends StatelessWidget {
  const _MyOrdersView({required this.scrollController});

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ScreenWrapper(
      child: BlocBuilder<OrdersCubit, OrdersState>(
        builder: (context, state) {
          if (state.isLoading && state.ordersResponse == null) {
            return const Center(child: Padding(padding: EdgeInsets.all(48), child: CircularProgressIndicator()));
          }

          if (state.errorMessage != null && state.ordersResponse == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: ColorName.danger),
                    const SizedBox(height: 16),
                    Text(
                      state.errorMessage!,
                      style: theme.textTheme.bodyLarge?.copyWith(color: ColorName.danger),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<OrdersCubit>().loadOrders(limit: 9999, offset: 0),
                      child: const Text('Попробовать снова'),
                    ),
                  ],
                ),
              ),
            );
          }

          final ordersResponse = state.ordersResponse;
          if (ordersResponse == null) {
            return const SizedBox.shrink();
          }

          final filteredOrders = _filterOrdersByTab(ordersResponse.orders, state.tab);

          return LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 1200;
              final sidebarWidth = isWide ? 320.0 : constraints.maxWidth;

              final content = Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _OrdersHero(totalOrders: ordersResponse.totalCount),
                          const SizedBox(height: 16),
                          _TabsRow(state: state),
                          const SizedBox(height: 12),
                          if (!isWide)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _Sidebar(
                                ordersResponse: ordersResponse,
                              ),
                            ),
                          if (filteredOrders.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text(
                                'В этой вкладке пока нет заказов',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: isDark ? ColorName.darkThemeTextSecondary : ColorName.textSecondary,
                                ),
                              ),
                            )
                          else ...[
                            _OrdersGrid(
                              orders: filteredOrders,
                              isWide: isWide,
                            ),
                            const SizedBox(height: 12),
                          ],
                          if (state.isLoading) ...[
                            const SizedBox(height: 12),
                            const Center(child: CircularProgressIndicator()),
                          ],
                        ],
                      ),
                    ),
                  ),
                  if (isWide)
                    SizedBox(
                      width: sidebarWidth,
                      child: AnimatedBuilder(
                        animation: scrollController,
                        builder: (context, child) {
                          final offset = -scrollController.offset;
                          return Transform.translate(
                            offset: Offset(0, offset),
                            child: child,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 20, 20),
                          child: _Sidebar(
                            ordersResponse: ordersResponse,
                          ),
                        ),
                      ),
                    ),
                ],
              );

              return Container(
                color: isDark ? ColorName.darkThemeBackground : ColorName.backgroundSecondary.withOpacity(0.3),
                child: content,
              );
            },
          );
        },
      ),
    );
  }
}

class _TabsRow extends StatelessWidget {
  const _TabsRow({required this.state});

  final OrdersState state;

  @override
  Widget build(BuildContext context) {
    final tabs = const [
      ('all', 'Все заказы'),
      ('current', 'Текущие'),
      ('history', 'История'),
      ('cancelled', 'Отменённые'),
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tabs
          .map(
            (tab) => ChoiceChip(
              label: Text(tab.$2),
              selected: state.tab == tab.$1,
              onSelected: (_) {
                final cubit = context.read<OrdersCubit>();
                cubit.loadOrders(
                  tab: tab.$1,
                  status: null,
                  offset: 0,
                  limit: 9999,
                );
              },
            ),
          )
          .toList(),
    );
  }
}

class _OrdersGrid extends StatelessWidget {
  const _OrdersGrid({
    required this.orders,
    required this.isWide,
  });

  final List<Order> orders;
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = 16.0;
        final itemsPerRow = isWide ? 2 : 1;

        // Группируем элементы по строкам
        final rows = <List<Order>>[];
        for (var i = 0; i < orders.length; i += itemsPerRow) {
          rows.add(orders.sublist(
            i,
            i + itemsPerRow > orders.length ? orders.length : i + itemsPerRow,
          ));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: rows.asMap().entries.map((rowEntry) {
            final rowIndex = rowEntry.key;
            final row = rowEntry.value;
            return Padding(
              padding: EdgeInsets.only(bottom: rowIndex < rows.length - 1 ? spacing : 0),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: row.asMap().entries.map((entry) {
                    final index = entry.key;
                    final order = entry.value;
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: index < row.length - 1 ? spacing : 0,
                        ),
                        child: OrderCard(order: order),
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.ordersResponse,
  });

  final OrdersResponse ordersResponse;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? ColorName.darkThemeCardBackground : ColorName.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? ColorName.darkThemeBorderSoft : ColorName.borderSoft),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 22,
                  offset: const Offset(0, 14),
                  spreadRadius: -10,
                ),
              ],
      ),
      child: OrdersSummarySection(summary: ordersResponse.summary),
    );
  }
}

class _OrdersHero extends StatelessWidget {
  const _OrdersHero({required this.totalOrders});

  final int totalOrders;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [ColorName.darkThemeBackgroundSecondary, ColorName.darkThemeCardBackground]
              : [ColorName.primary.withOpacity(0.08), ColorName.secondary.withOpacity(0.08)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isDark ? ColorName.darkThemeBorderSoft : ColorName.borderSoft),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 14),
                  spreadRadius: -8,
                ),
              ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Мои заказы',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: isDark ? ColorName.darkThemeTextPrimary : ColorName.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Следите за статусом отгрузок, доставок и историей — всё в одном месте.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: isDark ? ColorName.darkThemeTextSecondary : ColorName.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? ColorName.darkThemeBackgroundSecondary : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDark ? ColorName.darkThemeBorderSoft : ColorName.borderSoft),
            ),
            child: Column(
              children: [
                Text(
                  '$totalOrders',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? ColorName.darkThemeTextPrimary : ColorName.textPrimary,
                  ),
                ),
                Text(
                  'заказов',
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
  }
}
