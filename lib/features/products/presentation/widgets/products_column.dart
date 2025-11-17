import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_top_front/core/gen/colors.gen.dart';
import 'package:prime_top_front/core/utils/ral_color_helper.dart';
import 'package:prime_top_front/features/products/application/cubit/products_cubit.dart';
import 'package:prime_top_front/features/products/application/cubit/products_state.dart';

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

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                      ? ColorName.darkThemeCardBackground
                      : ColorName.cardBackground,
                  borderRadius: BorderRadius.circular(8),
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
                      width: 24,
                      height: 24,
                      margin: const EdgeInsets.only(right: 12, top: 2),
                      decoration: BoxDecoration(
                        color: RalColorHelper.getRalColor(product.colorCode),
                        borderRadius: BorderRadius.circular(4),
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
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  product.name,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: isDark
                                        ? ColorName.darkThemeTextPrimary
                                        : ColorName.textPrimary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'RAL ${product.colorCode}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: isDark
                                      ? ColorName.darkThemeTextSecondary
                                      : ColorName.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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

