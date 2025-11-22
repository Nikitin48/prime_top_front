import 'package:flutter/material.dart';
import 'package:prime_top_front/core/gen/colors.gen.dart';

class CartSummary extends StatelessWidget {
  const CartSummary({
    super.key,
    required this.totalPrice,
    required this.totalQuantity,
    required this.onCheckout,
    required this.isCheckingOut,
    required this.onClear,
    required this.isClearing,
  });

  final int totalPrice;
  final int totalQuantity;
  final VoidCallback onCheckout;
  final bool isCheckingOut;
  final VoidCallback onClear;
  final bool isClearing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      color: isDark
          ? ColorName.darkThemeCardBackground
          : ColorName.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark
              ? ColorName.darkThemeBorderSoft
              : ColorName.borderSoft,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Товаров:',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: isDark
                        ? ColorName.darkThemeTextSecondary
                        : ColorName.textSecondary,
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    '$totalQuantity шт.',
                    key: ValueKey<int>(totalQuantity),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: isDark
                          ? ColorName.darkThemeTextPrimary
                          : ColorName.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Итого:',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: isDark
                        ? ColorName.darkThemeTextPrimary
                        : ColorName.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    '$totalPrice ₽',
                    key: ValueKey<int>(totalPrice),
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: ColorName.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: isClearing ? null : onClear,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(
                        color: isClearing
                            ? ColorName.danger.withOpacity(0.5)
                            : ColorName.danger,
                      ),
                    ),
                    child: isClearing
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(
                            'Очистить корзину',
                            style: TextStyle(color: ColorName.danger),
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: isCheckingOut ? null : onCheckout,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: ColorName.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: isCheckingOut
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Оформить заказ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
