import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_top_front/core/gen/colors.gen.dart';
import 'package:prime_top_front/features/cart/application/cubit/cart_cubit.dart';
import 'package:prime_top_front/features/cart/application/cubit/cart_state.dart';
import 'package:prime_top_front/features/products/domain/entities/series.dart';
import 'package:prime_top_front/features/products/presentation/widgets/analyses_expansion_tile.dart';

class SeriesCard extends StatelessWidget {
  const SeriesCard({
    super.key,
    required this.series,
    required this.productId,
    this.onAddToCart,
  });

  final Series series;
  final int productId;
  final VoidCallback? onAddToCart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
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
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        series.name ?? 'Серия #${series.id}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: isDark
                              ? ColorName.darkThemeTextPrimary
                              : ColorName.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (onAddToCart != null)
                      BlocBuilder<CartCubit, CartState>(
                        builder: (context, cartState) {
                          final itemKey = '${productId}_${series.id}';
                          final isAddingThisItem = cartState.isAddingItem && cartState.addingItemKey == itemKey;
                          
                          return Container(
                            width: 48,
                            height: 48,
                            margin: const EdgeInsets.only(left: 12),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ColorName.primary,
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: isAddingThisItem ? null : onAddToCart,
                                borderRadius: BorderRadius.circular(24),
                                child: Center(
                                  child: isAddingThisItem
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          ),
                                        )
                                      : const Icon(
                                          Icons.shopping_cart_outlined,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
                if (series.productionDate != null || series.expireDate != null) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      if (series.productionDate != null)
                        _buildDateInfo(
                          context,
                          'Дата производства',
                          series.productionDate!,
                          isDark,
                        ),
                      if (series.expireDate != null)
                        _buildDateInfo(
                          context,
                          'Срок годности',
                          series.expireDate!,
                          isDark,
                        ),
                    ],
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      series.inStock ? Icons.check_circle : Icons.cancel,
                      size: 16,
                      color: series.inStock
                          ? ColorName.success
                          : ColorName.danger,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      series.inStock
                          ? 'В наличии: ${series.availableQuantity.toStringAsFixed(1)}'
                          : 'Нет в наличии',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: series.inStock
                            ? ColorName.success
                            : ColorName.danger,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (series.analyses != null)
            AnalysesExpansionTile(analyses: series.analyses!),
        ],
      ),
    );
  }

  Widget _buildDateInfo(
    BuildContext context,
    String label,
    DateTime date,
    bool isDark,
  ) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label: ',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isDark
                ? ColorName.darkThemeTextSecondary
                : ColorName.textSecondary,
          ),
        ),
        Text(
          '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isDark
                ? ColorName.darkThemeTextPrimary
                : ColorName.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

