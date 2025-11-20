import 'package:flutter/material.dart';
import 'package:prime_top_front/core/gen/colors.gen.dart';
import 'package:prime_top_front/core/widgets/series_card.dart';
import 'package:prime_top_front/features/products/domain/entities/series.dart';
import 'package:prime_top_front/features/stock/domain/entities/stock.dart';

class StockListSection extends StatelessWidget {
  const StockListSection({
    super.key,
    required this.stocks,
    this.title,
  });

  final List<Stock> stocks;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (stocks.isEmpty) {
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
            'Нет доступных остатков',
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
        if (title != null) ...[
          Text(
            title!,
            style: theme.textTheme.titleLarge?.copyWith(
              color: isDark
                  ? ColorName.darkThemeTextPrimary
                  : ColorName.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
        ],
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: stocks.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final stock = stocks[index];
            final series = _convertStockToSeries(stock);
            final productId = stock.product?.id ?? 0;
            final colorCode = stock.color ?? stock.product?.colorCode;
            final coatingTypeName = stock.coatingType?.name;
            
            return SeriesCard(
              series: series,
              productId: productId,
              productColorCode: colorCode,
              coatingTypeName: coatingTypeName,
            );
          },
        ),
      ],
    );
  }

  Series _convertStockToSeries(Stock stock) {
    return Series(
      id: stock.seriesId ?? stock.stocksId,
      name: stock.seriesName,
      productionDate: stock.productionDate,
      expireDate: stock.expireDate,
      analyses: stock.analyses,
      availableQuantity: stock.quantity,
      inStock: stock.quantity > 0,
    );
  }
}
