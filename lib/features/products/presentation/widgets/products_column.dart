import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:prime_top_front/core/gen/colors.gen.dart';
import 'package:prime_top_front/core/utils/ral_color_helper.dart';
import 'package:prime_top_front/features/coating_types/application/cubit/menu_cubit.dart';
import 'package:prime_top_front/features/products/application/cubit/products_cubit.dart';
import 'package:prime_top_front/features/products/application/cubit/products_state.dart';
import 'package:prime_top_front/features/products/domain/entities/product.dart';

class ProductsColumn extends StatelessWidget {
  const ProductsColumn({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: 400,
      decoration: BoxDecoration(
        color: isDark ? ColorName.darkThemeBackground : ColorName.background,
        border: Border(
          left: BorderSide(
            color: isDark ? ColorName.darkThemeBorderSoft : ColorName.borderSoft,
            width: 1,
          ),
        ),
      ),
      child: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          if (state.selectedCoatingTypeId == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text(
                  'Наведите на тип покрытия',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark
                        ? ColorName.darkThemeTextSecondary
                        : ColorName.textSecondary,
                  ),
                ),
              ),
            );
          }

          if (state.isLoading) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (state.errorMessage != null) {
            return Center(
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
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: ColorName.danger,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          if (state.products.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text(
                  'Продукты не найдены',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark
                        ? ColorName.darkThemeTextSecondary
                        : ColorName.textSecondary,
                  ),
                ),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
              final product = state.products[index];

              return _ProductCard(
                product: product,
                isDark: isDark,
                theme: theme,
                onTap: () {
                  // Закрываем меню при переходе на страницу продукта
                  context.read<MenuCubit>().closeMenu();
                  context.go('/products/${product.id}');
                },
              );
            },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Показать все',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: ColorName.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ProductCard extends StatefulWidget {
  const _ProductCard({
    required this.product,
    required this.isDark,
    required this.theme,
    required this.onTap,
  });

  final Product product;
  final bool isDark;
  final ThemeData theme;
  final VoidCallback onTap;

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.isDark
        ? ColorName.darkThemeCardBackground
        : ColorName.cardBackground;
    
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _isHovered
                ? Color.lerp(baseColor, ColorName.primary, 0.05)
                : baseColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: widget.isDark
                  ? ColorName.darkThemeBorderSoft
                  : ColorName.borderSoft,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 24,
                height: 24,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: RalColorHelper.getRalColor(widget.product.colorCode),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: widget.isDark
                        ? ColorName.darkThemeBorderSoft
                        : ColorName.borderSoft,
                    width: 1,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  widget.product.name,
                  style: widget.theme.textTheme.titleMedium?.copyWith(
                    color: widget.isDark
                        ? ColorName.darkThemeTextPrimary
                        : ColorName.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: widget.isDark
                    ? ColorName.darkThemeTextSecondary
                    : ColorName.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

