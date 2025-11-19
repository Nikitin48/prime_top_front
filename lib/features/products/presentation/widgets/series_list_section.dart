import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_top_front/core/gen/colors.gen.dart';
import 'package:prime_top_front/features/cart/application/cubit/cart_cubit.dart';
import 'package:prime_top_front/features/products/domain/entities/series.dart';
import 'package:prime_top_front/features/products/presentation/widgets/series_card.dart';

class SeriesListSection extends StatelessWidget {
  const SeriesListSection({
    super.key,
    required this.series,
    required this.productId,
  });

  final List<Series> series;
  final int productId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (series.isEmpty) {
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
        child: Center(
          child: Text(
            'Нет доступных серий в наличии',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: isDark
                  ? ColorName.darkThemeTextSecondary
                  : ColorName.textSecondary,
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Доступные серии (${series.length})',
          style: theme.textTheme.titleLarge?.copyWith(
            color: isDark
                ? ColorName.darkThemeTextPrimary
                : ColorName.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: series.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final currentSeries = series[index];
            return SeriesCard(
              series: currentSeries,
              productId: productId,
              onAddToCart: () {
                context.read<CartCubit>().addItemToCart(
                      productId: productId,
                      seriesId: currentSeries.id,
                      quantity: 1,
                    );
              },
            );
          },
        ),
      ],
    );
  }
}

