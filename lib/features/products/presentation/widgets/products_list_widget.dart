import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:prime_top_front/core/gen/colors.gen.dart';
import 'package:prime_top_front/core/widgets/pagination_controls.dart';
import 'package:prime_top_front/core/widgets/product_card.dart';
import 'package:prime_top_front/core/widgets/screen_wrapper.dart';
import 'package:prime_top_front/features/products/application/cubit/products_cubit.dart';
import 'package:prime_top_front/features/products/application/cubit/products_state.dart';

class ProductsListWidget extends StatefulWidget {
  const ProductsListWidget({
    super.key,
    required this.title,
    this.subtitle,
    required this.onLoadProducts,
    this.pageSize = 20,
  });

  final String title;
  final String? subtitle;
  final void Function(int page, int pageSize) onLoadProducts;
  final int pageSize;

  @override
  State<ProductsListWidget> createState() => _ProductsListWidgetState();
}

class _ProductsListWidgetState extends State<ProductsListWidget> {
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.onLoadProducts(_currentPage, widget.pageSize);
      }
    });
  }

  @override
  void didUpdateWidget(ProductsListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.title != widget.title || oldWidget.subtitle != widget.subtitle) {
      _currentPage = 0;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          widget.onLoadProducts(_currentPage, widget.pageSize);
        }
      });
    }
  }

  void _loadProducts(int page) {
    setState(() {
      _currentPage = page;
    });
    widget.onLoadProducts(page, widget.pageSize);
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      _loadProducts(_currentPage - 1);
    }
  }

  void _goToNextPage(int totalPages) {
    if (_currentPage < totalPages - 1) {
      _loadProducts(_currentPage + 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return ScreenWrapper(
      child: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          if (state.isLoading && state.products.isEmpty) {
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 32,
                vertical: isMobile ? 16 : 32,
              ).copyWith(top: isMobile ? 32 : 64),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1400),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context, theme, isMobile),
                    SizedBox(height: isMobile ? 16 : 32),
                    _buildLoadingState(context, theme, isMobile),
                  ],
                ),
              ),
            );
          }

          if (state.errorMessage != null && state.products.isEmpty) {
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 32,
                vertical: isMobile ? 16 : 32,
              ).copyWith(top: isMobile ? 32 : 64),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1400),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context, theme, isMobile),
                    SizedBox(height: isMobile ? 16 : 32),
                    _buildErrorState(context, theme, state.errorMessage!, isMobile),
                  ],
                ),
              ),
            );
          }

          if (state.products.isEmpty) {
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 32,
                vertical: isMobile ? 16 : 32,
              ).copyWith(top: isMobile ? 32 : 64),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1400),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context, theme, isMobile),
                    SizedBox(height: isMobile ? 16 : 32),
                    _buildEmptyState(context, theme, isDark, isMobile),
                  ],
                ),
              ),
            );
          }

          return _buildProductsGridWithHeader(context, theme, isDark, state);
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme, bool isMobile) {
    return Padding(
      padding: EdgeInsets.only(left: isMobile ? 0 : 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: (isMobile ? theme.textTheme.titleLarge : theme.textTheme.displaySmall)?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          if (widget.subtitle != null) ...[
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                widget.subtitle!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: ColorName.textSecondary,
                  fontSize: isMobile ? 14 : null,
                ),
              ),
            ),
          ] else
            BlocBuilder<ProductsCubit, ProductsState>(
              builder: (context, state) {
                if (state.totalCount > 0) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Найдено товаров: ${state.totalCount}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: ColorName.textSecondary,
                        fontSize: isMobile ? 14 : null,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context, ThemeData theme, bool isMobile) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 32.0 : 64.0),
        child: const CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, ThemeData theme, String errorMessage, bool isMobile) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 32.0 : 64.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: isMobile ? 48 : 64,
              color: ColorName.danger,
            ),
            SizedBox(height: isMobile ? 12 : 16),
            Text(
              errorMessage,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: ColorName.danger,
                fontSize: isMobile ? 14 : null,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: isMobile ? 16 : 24),
            ElevatedButton(
              onPressed: () {
                _loadProducts(0);
              },
              child: const Text('Повторить'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme, bool isDark, bool isMobile) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 32.0 : 64.0),
        child: Text(
          'Товары не найдены',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isDark
                ? ColorName.darkThemeTextSecondary
                : ColorName.textSecondary,
            fontSize: isMobile ? 14 : null,
          ),
        ),
      ),
    );
  }

  Widget _buildProductsGridWithHeader(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    ProductsState state,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isMobile = screenWidth < 600;
        final cardsPerRow = _getCardsPerRow(screenWidth);
        final spacing = screenWidth < 600 ? 12.0 : screenWidth < 900 ? 16.0 : 20.0;
        final totalSpacing = spacing * (cardsPerRow - 1);
        final availableWidth = constraints.maxWidth.clamp(0.0, 1400.0);
        final sidePadding = isMobile ? 0.0 : 100.0;
        final cardWidth = (availableWidth - totalSpacing - sidePadding) / cardsPerRow;
        
        double cardHeight;
        if (screenWidth < 600) {
          cardHeight = (cardWidth * 1.3).clamp(240.0, 300.0);
        } else if (screenWidth < 900) {
          cardHeight = (cardWidth * 1.25).clamp(260.0, 320.0);
        } else if (screenWidth < 1400) {
          cardHeight = (cardWidth * 1.15).clamp(240.0, 300.0);
        } else {
          cardHeight = (cardWidth * 1.1).clamp(220.0, 280.0);
        }

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 32,
            vertical: isMobile ? 16 : 32,
          ).copyWith(top: isMobile ? 32 : 64),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, theme, isMobile),
                SizedBox(height: isMobile ? 16 : 32),
                Padding(
                  padding: EdgeInsets.only(
                    left: isMobile ? 0 : 50,
                    right: isMobile ? 0 : 50,
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cardsPerRow,
                      crossAxisSpacing: spacing,
                      mainAxisSpacing: spacing,
                      childAspectRatio: cardWidth / cardHeight,
                    ),
                    itemCount: state.products.length,
                    itemBuilder: (context, index) {
                      final product = state.products[index];
                      return ProductCard(
                        product: product,
                        showPrice: true,
                        cardStyle: ProductCardStyle.featured,
                        cardWidth: cardWidth,
                        cardHeight: cardHeight,
                        onTap: () {
                          context.go('/products/${product.id}');
                        },
                      );
                    },
                  ),
                ),
                if (state.totalCount > widget.pageSize) ...[
                  SizedBox(height: isMobile ? 16 : 32),
                  _buildPagination(context, theme, isDark, state, isMobile),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPagination(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    ProductsState state,
    bool isMobile,
  ) {
    final totalPages = (state.totalCount / widget.pageSize).ceil();

    return Padding(
      padding: EdgeInsets.only(
        left: isMobile ? 0 : 50,
        right: isMobile ? 0 : 50,
      ),
      child: PaginationControls(
        currentPage: _currentPage,
        totalPages: totalPages,
        pageSize: widget.pageSize,
        totalCount: state.totalCount,
        onPreviousPage: _currentPage > 0 ? _goToPreviousPage : null,
        onNextPage: _currentPage < totalPages - 1
            ? () => _goToNextPage(totalPages)
            : null,
      ),
    );
  }

  int _getCardsPerRow(double screenWidth) {
    if (screenWidth < 600) {
      return 1;
    } else if (screenWidth < 900) {
      return 2;
    } else if (screenWidth < 1200) {
      return 3;
    } else {
      return 4;
    }
  }
}
