import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:prime_top_front/core/gen/colors.gen.dart';
import 'package:prime_top_front/core/widgets/pagination_controls.dart';
import 'package:prime_top_front/core/widgets/screen_wrapper.dart';
import 'package:prime_top_front/features/admin/application/cubit/admin_orders_cubit.dart';
import 'package:prime_top_front/features/admin/application/cubit/admin_orders_state.dart';
import 'package:prime_top_front/features/orders/domain/entities/order.dart';
import 'package:prime_top_front/features/orders/presentation/widgets/order_card.dart';

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

class AdminOrdersPage extends StatefulWidget {
  const AdminOrdersPage({super.key});

  @override
  State<AdminOrdersPage> createState() => _AdminOrdersPageState();
}

class _AdminOrdersPageState extends State<AdminOrdersPage> {
  final _scrollController = ScrollController();
  String _currentTab = 'all';
  int _currentPage = 0;
  static const int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadOrders();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadOrders() {
    context.read<AdminOrdersCubit>().loadOrders(
          limit: _pageSize,
          offset: _currentPage * _pageSize,
        );
  }

  @override
  Widget build(BuildContext context) {
    return _AdminOrdersView(
      scrollController: _scrollController,
      currentTab: _currentTab,
      onTabChanged: (tab) {
        setState(() {
          _currentTab = tab;
          _currentPage = 0;
        });
        _loadOrders();
      },
      currentPage: _currentPage,
      pageSize: _pageSize,
      onPageChanged: (page) {
        setState(() {
          _currentPage = page;
        });
        _loadOrders();
      },
    );
  }
}

class _AdminOrdersView extends StatelessWidget {
  const _AdminOrdersView({
    required this.scrollController,
    required this.currentTab,
    required this.onTabChanged,
    required this.currentPage,
    required this.pageSize,
    required this.onPageChanged,
  });

  final ScrollController scrollController;
  final String currentTab;
  final ValueChanged<String> onTabChanged;
  final int currentPage;
  final int pageSize;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ScreenWrapper(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: BlocBuilder<AdminOrdersCubit, AdminOrdersState>(
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
                      onPressed: () => context.read<AdminOrdersCubit>().loadOrders(
                            limit: pageSize,
                            offset: currentPage * pageSize,
                          ),
                      child: const Text('Попробовать снова'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state.searchedOrder != null) {
            return _buildSearchResult(context, theme, isDark, state.searchedOrder!);
          }

          final ordersResponse = state.ordersResponse;
          if (ordersResponse == null) {
            return const SizedBox.shrink();
          }

          final filteredOrders = _filterOrdersByTab(ordersResponse.orders, currentTab);

          return LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 1200;

              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1400),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _OrdersHero(totalOrders: ordersResponse.totalCount),
                        const SizedBox(height: 16),
                        _SearchField(),
                        const SizedBox(height: 16),
                        _TabsRow(currentTab: currentTab, onTabChanged: onTabChanged),
                        const SizedBox(height: 12),
                        if (state.isSearching)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(48),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        else if (state.errorMessage != null && state.searchQuery != null)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.search_off, size: 48, color: ColorName.danger),
                                  const SizedBox(height: 16),
                                  Text(
                                    state.errorMessage!,
                                    style: theme.textTheme.bodyLarge?.copyWith(color: ColorName.danger),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () => context.read<AdminOrdersCubit>().clearSearch(),
                                    child: const Text('Очистить поиск'),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else if (filteredOrders.isEmpty)
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
                          _OrdersGrid(orders: filteredOrders, isWide: isWide),
                          const SizedBox(height: 12),
                        ],
                        if (ordersResponse.totalCount > pageSize) ...[
                          const SizedBox(height: 24),
                          PaginationControls(
                            currentPage: currentPage,
                            totalPages: (ordersResponse.totalCount / pageSize).ceil(),
                            pageSize: pageSize,
                            totalCount: ordersResponse.totalCount,
                            onPreviousPage: currentPage > 0
                                ? () => onPageChanged(currentPage - 1)
                                : null,
                            onNextPage: currentPage < (ordersResponse.totalCount / pageSize).ceil() - 1
                                ? () => onPageChanged(currentPage + 1)
                                : null,
                          ),
                        ],
                        if (state.isLoading) ...[
                          const SizedBox(height: 12),
                          const Center(child: CircularProgressIndicator()),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSearchResult(BuildContext context, ThemeData theme, bool isDark, Order order) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 1200;

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1400),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _OrdersHero(totalOrders: 1),
                  const SizedBox(height: 16),
                  _SearchField(),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        'Результат поиска',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: isDark ? ColorName.darkThemeTextPrimary : ColorName.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () => context.read<AdminOrdersCubit>().clearSearch(),
                        icon: const Icon(Icons.clear),
                        label: const Text('Очистить поиск'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  isWide
                      ? SizedBox(
                          width: double.infinity,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: OrderCard(
                                  order: order,
                                  onTap: () => context.goNamed('order_detail', pathParameters: {'orderId': '${order.id}'}),
                                ),
                              ),
                            ],
                          ),
                        )
                      : OrderCard(
                          order: order,
                          onTap: () => context.goNamed('order_detail', pathParameters: {'orderId': '${order.id}'}),
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SearchField extends StatefulWidget {
  const _SearchField();

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    if (query.trim().isEmpty) {
      context.read<AdminOrdersCubit>().clearSearch();
    } else {
      context.read<AdminOrdersCubit>().searchOrderById(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<AdminOrdersCubit, AdminOrdersState>(
      builder: (context, state) {
        if (state.searchQuery == null && _controller.text.isNotEmpty) {
          _controller.clear();
        }

        return Container(
          decoration: BoxDecoration(
            color: isDark ? ColorName.darkThemeCardBackground : ColorName.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDark ? ColorName.darkThemeBorderSoft : ColorName.borderSoft),
          ),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: 'Поиск по номеру заказа',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: state.searchQuery != null
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _controller.clear();
                        context.read<AdminOrdersCubit>().clearSearch();
                        _focusNode.unfocus();
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.search,
            onSubmitted: _onSearch,
            onChanged: (value) {
            },
          ),
        );
      },
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
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Все заказы',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: isDark ? ColorName.darkThemeTextPrimary : ColorName.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Всего заказов: $totalOrders',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: isDark ? ColorName.darkThemeTextSecondary : ColorName.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.receipt_long_outlined,
            size: 32,
            color: isDark ? ColorName.darkThemeTextSecondary : ColorName.primary,
          ),
        ],
      ),
    );
  }
}

class _TabsRow extends StatelessWidget {
  const _TabsRow({
    required this.currentTab,
    required this.onTabChanged,
  });

  final String currentTab;
  final ValueChanged<String> onTabChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? ColorName.darkThemeCardBackground : ColorName.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? ColorName.darkThemeBorderSoft : ColorName.borderSoft),
      ),
      child: Row(
        children: [
          _TabButton(
            label: 'Все',
            isActive: currentTab == 'all',
            onTap: () => onTabChanged('all'),
          ),
          _TabButton(
            label: 'Активные',
            isActive: currentTab == 'active',
            onTap: () => onTabChanged('active'),
          ),
          _TabButton(
            label: 'История',
            isActive: currentTab == 'history',
            onTap: () => onTabChanged('history'),
          ),
          _TabButton(
            label: 'Отмененные',
            isActive: currentTab == 'cancelled',
            onTap: () => onTabChanged('cancelled'),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: isActive
                ? (isDark ? ColorName.darkThemePrimary : ColorName.primary)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isActive
                    ? Colors.white
                    : (isDark ? ColorName.darkThemeTextSecondary : ColorName.textSecondary),
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
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
    if (isWide) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
        ),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return OrderCard(
            order: order,
            onTap: () => context.goNamed('order_detail', pathParameters: {'orderId': '${order.id}'}),
          );
        },
      );
    }

    return Column(
      children: orders
          .map((order) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: OrderCard(
                  order: order,
                  onTap: () => context.goNamed('order_detail', pathParameters: {'orderId': '${order.id}'}),
                ),
              ))
          .toList(),
    );
  }
}
