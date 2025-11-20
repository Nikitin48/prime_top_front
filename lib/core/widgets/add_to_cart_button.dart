import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:prime_top_front/core/gen/colors.gen.dart';
import 'package:prime_top_front/features/auth/application/cubit/auth_cubit.dart';
import 'package:prime_top_front/features/auth/presentation/widgets/auth_dialog.dart';
import 'package:prime_top_front/features/cart/application/cubit/cart_cubit.dart';
import 'package:prime_top_front/features/cart/application/cubit/cart_state.dart';

class AddToCartButton extends StatelessWidget {
  const AddToCartButton({
    super.key,
    required this.productId,
    this.seriesId,
    this.size = 56,
    this.iconSize = 24,
  });

  final int productId;
  final int? seriesId;
  final double size;
  final double iconSize;

  Future<void> _handleAddToCart(BuildContext context) async {
    final authState = context.read<AuthCubit>().state;
    if (authState.status != AuthStatus.authenticated) {
      if (context.mounted) {
        showDialog<void>(
          context: context,
          barrierDismissible: true,
          builder: (context) => const AuthDialog(),
        );
      }
      return;
    }

    final cartCubit = context.read<CartCubit>();
    await cartCubit.addItemToCart(
      productId: productId,
      seriesId: seriesId,
      quantity: 1,
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Товар добавлен в корзину'),
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: 'Перейти',
            textColor: Colors.white,
            onPressed: () {
              context.go('/cart');
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, cartState) {
        final itemKey = seriesId != null ? '${productId}_$seriesId' : '${productId}_null';
        final isAddingThisItem = cartState.isAddingItem && cartState.addingItemKey == itemKey;

        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ColorName.primary,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isAddingThisItem
                  ? null
                  : () => _handleAddToCart(context),
              borderRadius: BorderRadius.circular(size / 2),
              child: Center(
                child: isAddingThisItem
                    ? SizedBox(
                        width: iconSize,
                        height: iconSize,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Icon(
                        Icons.shopping_cart_outlined,
                        color: Colors.white,
                        size: iconSize,
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}

