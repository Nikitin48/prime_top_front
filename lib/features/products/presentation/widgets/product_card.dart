import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:prime_top_front/core/gen/colors.gen.dart';
import 'package:prime_top_front/core/utils/ral_color_helper.dart';
import 'package:prime_top_front/core/widgets/add_to_cart_button.dart';
import 'package:prime_top_front/features/products/domain/entities/product.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.showPrice = true,
    this.showPopularity = false,
    this.totalOrdered,
    this.cardStyle = ProductCardStyle.standard,
  });

  final Product product;
  final VoidCallback? onTap;
  final bool showPrice;
  final bool showPopularity;
  final double? totalOrdered;
  final ProductCardStyle cardStyle;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

enum ProductCardStyle {
  standard,
  compact,
  featured,
}

class _ProductCardState extends State<ProductCard> {
  bool _isHovered = false;

  void _handleTap() {
    if (widget.onTap != null) {
      widget.onTap!();
    } else {
      context.go('/products/${widget.product.id}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    switch (widget.cardStyle) {
      case ProductCardStyle.compact:
        return _buildCompactCard(context, theme, isDark);
      case ProductCardStyle.featured:
        return _buildFeaturedCard(context, theme, isDark);
      case ProductCardStyle.standard:
        return _buildStandardCard(context, theme, isDark);
    }
  }

  Widget _buildStandardCard(BuildContext context, ThemeData theme, bool isDark) {
    final baseColor = isDark
        ? ColorName.darkThemeCardBackground
        : ColorName.cardBackground;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: _handleTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _isHovered
                ? Color.lerp(baseColor, ColorName.primary, 0.03)
                : baseColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered
                  ? ColorName.primary.withValues(alpha: 0.3)
                  : (isDark ? ColorName.darkThemeBorderSoft : ColorName.borderSoft),
              width: _isHovered ? 1.5 : 1,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: ColorName.primary.withValues(alpha: 0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: RalColorHelper.getRalColor(widget.product.colorCode),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark
                            ? ColorName.darkThemeBorderSoft
                            : ColorName.borderSoft,
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'RAL ${widget.product.colorCode}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: _getContrastColor(
                            RalColorHelper.getRalColor(widget.product.colorCode),
                          ),
                          fontWeight: FontWeight.w600,
                          fontSize: 9,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: isDark
                                ? ColorName.darkThemeTextPrimary
                                : ColorName.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.product.coatingType.name,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isDark
                                ? ColorName.darkThemeTextSecondary
                                : ColorName.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (widget.showPrice)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.product.price} ₽',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: ColorName.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (widget.showPopularity && widget.totalOrdered != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              'Заказано: ${widget.totalOrdered!.toStringAsFixed(1)}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: isDark
                                    ? ColorName.darkThemeTextSecondary
                                    : ColorName.textSecondary,
                              ),
                            ),
                          ),
                      ],
                    ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: isDark
                        ? ColorName.darkThemeTextSecondary
                        : ColorName.textSecondary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactCard(BuildContext context, ThemeData theme, bool isDark) {
    final baseColor = isDark
        ? ColorName.darkThemeCardBackground
        : ColorName.cardBackground;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: _handleTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _isHovered
                ? Color.lerp(baseColor, ColorName.primary, 0.05)
                : baseColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark
                  ? ColorName.darkThemeBorderSoft
                  : ColorName.borderSoft,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 32,
                height: 32,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: RalColorHelper.getRalColor(widget.product.colorCode),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDark
                        ? ColorName.darkThemeBorderSoft
                        : ColorName.borderSoft,
                    width: 1,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: isDark
                            ? ColorName.darkThemeTextPrimary
                            : ColorName.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.showPrice) ...[
                      const SizedBox(height: 4),
                      Text(
                        '${widget.product.price} ₽',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: ColorName.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: isDark
                    ? ColorName.darkThemeTextSecondary
                    : ColorName.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedCard(BuildContext context, ThemeData theme, bool isDark) {
    final baseColor = isDark
        ? ColorName.darkThemeCardBackground
        : ColorName.cardBackground;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: _handleTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: _isHovered
                ? Color.lerp(baseColor, ColorName.primary, 0.05)
                : baseColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _isHovered
                  ? ColorName.primary.withValues(alpha: 0.4)
                  : (isDark ? ColorName.darkThemeBorderSoft : ColorName.borderSoft),
              width: _isHovered ? 2 : 1,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: ColorName.primary.withValues(alpha: 0.15),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: RalColorHelper.getRalColor(widget.product.colorCode),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark
                            ? ColorName.darkThemeBorderSoft
                            : ColorName.borderSoft,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'RAL\n${widget.product.colorCode}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: _getContrastColor(
                            RalColorHelper.getRalColor(widget.product.colorCode),
                          ),
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (widget.showPopularity && widget.totalOrdered != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: ColorName.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.trending_up,
                            size: 16,
                            color: ColorName.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.totalOrdered!.toStringAsFixed(0)}',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: ColorName.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                widget.product.name,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: isDark
                      ? ColorName.darkThemeTextPrimary
                      : ColorName.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                widget.product.coatingType.name,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? ColorName.darkThemeTextSecondary
                      : ColorName.textSecondary,
                ),
              ),
              const Spacer(),
              if (widget.showPrice)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${widget.product.price} ₽',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: ColorName.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    AddToCartButton(
                      productId: widget.product.id,
                      size: 48,
                      iconSize: 20,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getContrastColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}

