import 'package:flutter/material.dart';
import 'package:prime_top_front/core/gen/colors.gen.dart';
import 'package:prime_top_front/core/utils/ral_color_helper.dart';
import 'package:prime_top_front/core/widgets/add_to_cart_button.dart';
import 'package:prime_top_front/features/coating_types/domain/entities/coating_type.dart';
import 'package:prime_top_front/features/products/domain/entities/product.dart';
import 'package:prime_top_front/features/products/domain/entities/series.dart';

class ProductInfoSection extends StatelessWidget {
  const ProductInfoSection({
    super.key,
    required this.product,
    required this.coatingType,
    this.availableSeries,
  });

  final Product product;
  final CoatingType coatingType;
  final List<Series>? availableSeries;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(24),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64,
            height: 64,
            margin: const EdgeInsets.only(right: 24),
            decoration: BoxDecoration(
              color: RalColorHelper.getRalColor(product.colorCode),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark
                    ? ColorName.darkThemeBorderSoft
                    : ColorName.borderSoft,
                width: 2,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: isDark
                        ? ColorName.darkThemeTextPrimary
                        : ColorName.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Тип покрытия: ${coatingType.name} (${coatingType.nomenclature})',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: isDark
                        ? ColorName.darkThemeTextSecondary
                        : ColorName.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Код цвета: ${product.colorCode}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark
                        ? ColorName.darkThemeTextSecondary
                        : ColorName.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Цена: ${product.price} ₽',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: isDark
                        ? ColorName.darkThemeTextPrimary
                        : ColorName.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          AddToCartButton(
            productId: product.id,
            size: 56,
            iconSize: 24,
          ),
        ],
      ),
    );
  }
}

