import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:prime_top_front/core/gen/colors.gen.dart';
import 'package:prime_top_front/core/widgets/screen_wrapper.dart';
import 'package:prime_top_front/features/cart/application/cubit/cart_cubit.dart';
import 'package:prime_top_front/features/cart/application/cubit/cart_state.dart';
import 'package:prime_top_front/features/cart/presentation/widgets/cart_item_card.dart';
import 'package:prime_top_front/features/cart/presentation/widgets/cart_summary.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<CartCubit>().loadCart();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const _CartView();
  }
}

class _CartView extends StatelessWidget {
  const _CartView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ScreenWrapper(
      child: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.isLoading) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: const Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }

          if (state.errorMessage != null) {
            return Center(
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
                          context.read<CartCubit>().loadCart();
                        },
                        child: const Text('Повторить'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          if (state.cart == null || state.cart!.items.isEmpty) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Padding(
                  padding: const EdgeInsets.all(32.0).copyWith(top: 120),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 64,
                        color: isDark
                            ? ColorName.darkThemeTextSecondary
                            : ColorName.textSecondary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Корзина пуста',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: isDark
                              ? ColorName.darkThemeTextPrimary
                              : ColorName.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Добавьте товары в корзину',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: isDark
                              ? ColorName.darkThemeTextSecondary
                              : ColorName.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          final cart = state.cart!;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Корзина',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: isDark
                            ? ColorName.darkThemeTextPrimary
                            : ColorName.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Позиций: ${cart.itemsCount} • Всего товаров: ${cart.totalQuantity}',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: isDark
                            ? ColorName.darkThemeTextSecondary
                            : ColorName.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 32),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cart.items.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final item = cart.items[index];
                        return CartItemCard(
                          cartItem: item,
                          onQuantityChanged: (newQuantity) {
                            context.read<CartCubit>().updateCartItemQuantity(
                                  cartItemId: item.id,
                                  quantity: newQuantity,
                                );
                          },
                          onRemove: () {
                            context.read<CartCubit>().removeCartItem(item.id);
                          },
                          isRemoving: state.isRemovingItem,
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    CartSummary(
                      totalPrice: cart.totalPrice,
                      totalQuantity: cart.totalQuantity,
                      onCheckout: () async {
                        final orderId = await context.read<CartCubit>().checkout();
                        if (orderId != null && context.mounted) {
                          context.goNamed('order_detail', pathParameters: {'orderId': orderId.toString()});
                        } else if (state.errorMessage != null && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.errorMessage!),
                              backgroundColor: ColorName.danger,
                            ),
                          );
                        }
                      },
                      isCheckingOut: state.isCheckingOut,
                      onClear: () {
                        showDialog<void>(
                          context: context,
                          builder: (dialogContext) => AlertDialog(
                            title: const Text('Очистить корзину?'),
                            content: const Text('Вы уверены, что хотите удалить все товары из корзины?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(dialogContext).pop(),
                                child: const Text('Отмена'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(dialogContext).pop();
                                  context.read<CartCubit>().clearCart();
                                },
                                child: const Text('Очистить', style: TextStyle(color: ColorName.danger)),
                              ),
                            ],
                          ),
                        );
                      },
                      isClearing: state.isClearing,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

