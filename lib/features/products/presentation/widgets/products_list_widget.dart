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

    return ScreenWrapper(
      child: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          if (state.isLoading && state.products.isEmpty) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32).copyWith(top: 64),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1400),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context, theme),
                    const SizedBox(height: 32),
                    _buildLoadingState(context, theme),
                  ],
                ),
              ),
            );
          }

          if (state.errorMessage != null && state.products.isEmpty) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32).copyWith(top: 64),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1400),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context, theme),
                    const SizedBox(height: 32),
                    _buildErrorState(context, theme, state.errorMessage!),
                  ],
                ),
              ),
            );
          }

          if (state.products.isEmpty) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32).copyWith(top: 64),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1400),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context, theme),
                    const SizedBox(height: 32),
                    _buildEmptyState(context, theme, isDark),
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

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(left: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          if (widget.subtitle != null) ...[
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                widget.subtitle!,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: ColorName.textSecondary,
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
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: ColorName.textSecondary,
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

  Widget _buildLoadingState(BuildContext context, ThemeData theme) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(64.0),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, ThemeData theme, String errorMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(64.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: ColorName.danger,
            ),
            const SizedBox(height: 16),
            Text(
              errorMessage,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: ColorName.danger,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
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

  Widget _buildEmptyState(BuildContext context, ThemeData theme, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(64.0),
        child: Text(
          'Товары не найдены',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: isDark
                ? ColorName.darkThemeTextSecondary
                : ColorName.textSecondary,
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
        final cardsPerRow = _getCardsPerRow(screenWidth);
        final spacing = screenWidth < 600 ? 12.0 : screenWidth < 900 ? 16.0 : 20.0;
        final totalSpacing = spacing * (cardsPerRow - 1);
        final availableWidth = constraints.maxWidth.clamp(0.0, 1400.0);
        final cardWidth = (availableWidth - totalSpacing - 100) / cardsPerRow;
        
        double cardHeight;
        if (screenWidth < 600) {
          cardHeight = (cardWidth * 1.4).clamp(280.0, 350.0);
        } else if (screenWidth < 900) {
          cardHeight = (cardWidth * 1.25).clamp(260.0, 320.0);
        } else if (screenWidth < 1400) {
          cardHeight = (cardWidth * 1.15).clamp(240.0, 300.0);
        } else {
          cardHeight = (cardWidth * 1.1).clamp(220.0, 280.0);
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32).copyWith(top: 64),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, theme),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.only(left: 50, right: 50),
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
                  const SizedBox(height: 32),
                  _buildPagination(context, theme, isDark, state),
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
  ) {
    final totalPages = (state.totalCount / widget.pageSize).ceil();

    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50),
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

