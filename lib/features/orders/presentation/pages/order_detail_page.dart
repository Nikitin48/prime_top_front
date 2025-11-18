import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:prime_top_front/core/gen/colors.gen.dart';
import 'package:prime_top_front/core/widgets/screen_wrapper.dart';
import 'package:prime_top_front/features/orders/application/cubit/order_detail_cubit.dart';
import 'package:prime_top_front/features/orders/application/cubit/order_detail_state.dart';
import 'package:prime_top_front/features/orders/presentation/widgets/order_info_section.dart';
import 'package:prime_top_front/features/orders/presentation/widgets/order_items_section.dart';
import 'package:prime_top_front/features/orders/presentation/widgets/order_status_history_section.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({super.key, required this.orderId});

  final int orderId;

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<OrderDetailCubit>().loadOrder(widget.orderId);
      }
    });
  }

  @override
  void didUpdateWidget(OrderDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.orderId != widget.orderId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<OrderDetailCubit>().loadOrder(widget.orderId);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return const _OrderDetailView();
  }
}

class _OrderDetailView extends StatelessWidget {
  const _OrderDetailView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<OrderDetailCubit, OrderDetailState>(
      builder: (context, state) {
        if (state.isLoading) {
          return ScreenWrapper(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: const Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          );
        }

        if (state.errorMessage != null) {
          return ScreenWrapper(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: ColorName.danger,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state.errorMessage!,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: ColorName.danger,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          final orderId = GoRouterState.of(context).pathParameters['orderId'];
                          if (orderId != null) {
                            context.read<OrderDetailCubit>().loadOrder(int.parse(orderId));
                          }
                        },
                        child: const Text('Повторить'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        if (state.order == null) {
          return ScreenWrapper(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text(
                    'Заказ не найден',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: isDark
                          ? ColorName.darkThemeTextSecondary
                          : ColorName.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        final order = state.order!;

        return ScreenWrapper(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OrderInfoSection(order: order),
                    const SizedBox(height: 24),
                    OrderItemsSection(items: order.items),
                    if (order.statusHistory.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      OrderStatusHistorySection(history: order.statusHistory),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

