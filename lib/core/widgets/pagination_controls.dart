import 'package:flutter/material.dart';
import 'package:prime_top_front/core/gen/colors.gen.dart';

class PaginationControls extends StatelessWidget {
  const PaginationControls({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPreviousPage,
    required this.onNextPage,
    this.pageSize,
    this.totalCount,
  });

  final int currentPage;
  final int totalPages;
  final VoidCallback? onPreviousPage;
  final VoidCallback? onNextPage;
  final int? pageSize;
  final int? totalCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: onPreviousPage,
            icon: const Icon(Icons.chevron_left),
          ),
          Text(
            _buildPageInfo(),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark
                  ? ColorName.darkThemeTextPrimary
                  : ColorName.textPrimary,
            ),
          ),
          IconButton(
            onPressed: onNextPage,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }

  String _buildPageInfo() {
    if (totalCount != null && pageSize != null) {
      final start = (currentPage * pageSize!) + 1;
      final end = ((currentPage + 1) * pageSize! < totalCount!)
          ? (currentPage + 1) * pageSize!
          : totalCount;
      return 'Страница ${currentPage + 1} из $totalPages ($start-$end из $totalCount)';
    }
    return 'Страница ${currentPage + 1} из $totalPages';
  }
}



