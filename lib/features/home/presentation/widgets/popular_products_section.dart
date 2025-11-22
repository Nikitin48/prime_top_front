import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:prime_top_front/core/gen/colors.gen.dart';
import 'package:prime_top_front/features/home/application/cubit/top_products_cubit.dart';
import 'package:prime_top_front/features/home/application/cubit/top_products_state.dart';
import 'package:prime_top_front/features/home/domain/entities/popular_product.dart';
import 'package:prime_top_front/core/widgets/product_card.dart';

class PopularProductsSection extends StatefulWidget {
  const PopularProductsSection({super.key});

  @override
  State<PopularProductsSection> createState() => _PopularProductsSectionState();
}

class _PopularProductsSectionState extends State<PopularProductsSection> {
  @override
  void initState() {
    super.initState();
    context.read<TopProductsCubit>().loadTopProducts();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return BlocBuilder<TopProductsCubit, TopProductsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return _buildLoadingState(context, theme, isDark, isMobile);
        }

        if (state.errorMessage != null) {
          return _buildErrorState(context, theme, isDark, state.errorMessage!, isMobile);
        }

        if (state.products.isEmpty) {
          return const SizedBox.shrink();
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
                _buildSectionHeader(context, theme, isMobile),
                SizedBox(height: isMobile ? 16 : 24),
                _ProductsScrollSection(products: state.products),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context, ThemeData theme, bool isMobile) {
    return Padding(
      padding: EdgeInsets.only(left: isMobile ? 0 : 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Популярные товары',
            style: (isMobile ? theme.textTheme.titleLarge : theme.textTheme.displaySmall)?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          
        ],
      ),
    );
  }

  Widget _buildLoadingState(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    bool isMobile,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 32,
        vertical: isMobile ? 16 : 32,
      ).copyWith(top: isMobile ? 32 : 64),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: Column(
          children: [
            _buildSectionHeader(context, theme, isMobile),
            SizedBox(height: isMobile ? 16 : 32),
            Center(
              child: Padding(
                padding: EdgeInsets.all(isMobile ? 32.0 : 64.0),
                child: const CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    String errorMessage,
    bool isMobile,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 32,
        vertical: isMobile ? 16 : 32,
      ).copyWith(top: isMobile ? 32 : 64),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: Column(
          children: [
            _buildSectionHeader(context, theme, isMobile),
            SizedBox(height: isMobile ? 16 : 32),
            Center(
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
                        context.read<TopProductsCubit>().loadTopProducts();
                      },
                      child: const Text('Повторить'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductsScrollSection extends StatefulWidget {
  const _ProductsScrollSection({
    required this.products,
  });

  final List<PopularProduct> products;

  @override
  State<_ProductsScrollSection> createState() => _ProductsScrollSectionState();
}

class _ProductsScrollSectionState extends State<_ProductsScrollSection> {
  late final ScrollController _scrollController;
  bool _showLeftButton = false;
  bool _showRightButton = true;
  double _scrollDistance = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_updateButtonVisibility);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateButtonVisibility();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateButtonVisibility);
    _scrollController.dispose();
    super.dispose();
  }

  void _updateButtonVisibility() {
    if (!_scrollController.hasClients) return;
    
    final position = _scrollController.position;
    setState(() {
      _showLeftButton = position.pixels > 0;
      _showRightButton = position.pixels < position.maxScrollExtent;
    });
  }

  void _scrollLeft() {
    if (!_scrollController.hasClients || _scrollDistance == 0) return;
    
    final currentPosition = _scrollController.position.pixels;
    final targetPosition = (currentPosition - _scrollDistance).clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );
    
    _scrollController.animateTo(
      targetPosition,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _scrollRight() {
    if (!_scrollController.hasClients || _scrollDistance == 0) return;
    
    final currentPosition = _scrollController.position.pixels;
    final targetPosition = (currentPosition + _scrollDistance).clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );
    
    _scrollController.animateTo(
      targetPosition,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (widget.products.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final cardsPerRow = _getCardsPerRow(screenWidth);
        final horizontalPadding = _showLeftButton || _showRightButton ? 48.0 : 0.0;
        final availableWidth = constraints.maxWidth - horizontalPadding;
        
        final spacing = screenWidth < 600 ? 12.0 : screenWidth < 900 ? 16.0 : 20.0;
        final totalSpacing = spacing * (cardsPerRow - 1);
        final cardWidth = (availableWidth - totalSpacing) / cardsPerRow;
        final cardWidthWithSpacing = cardWidth + spacing;
   
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
        
        if (_scrollDistance != cardWidthWithSpacing) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _scrollDistance = cardWidthWithSpacing;
            });
            _updateButtonVisibility();
          });
        }
        
        final isMobile = screenWidth < 600;
        final adjustedHorizontalPadding = isMobile ? 0.0 : horizontalPadding;
        
        return Stack(
          children: [
            if (_showLeftButton)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: _ScrollButton(
                  icon: Icons.chevron_left,
                  onPressed: _scrollLeft,
                  isDark: isDark,
                ),
              ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: adjustedHorizontalPadding),
              child: SizedBox(
                height: cardHeight,
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.products.length,
                  itemExtent: cardWidthWithSpacing,
                  itemBuilder: (context, index) {
                    final popularProduct = widget.products[index];
                    return Container(
                      width: cardWidth,
                      height: cardHeight,
                      margin: EdgeInsets.only(
                        right: index < widget.products.length - 1 ? spacing : 0,
                      ),
                      child: ProductCard(
                        product: popularProduct.product,
                        showPrice: true,
                        showPopularity: true,
                        totalOrdered: popularProduct.totalOrdered,
                        cardStyle: ProductCardStyle.featured,
                        cardWidth: cardWidth,
                        cardHeight: cardHeight,
                        onTap: () {
                          context.go('/products/${popularProduct.product.id}');
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            if (_showRightButton)
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: _ScrollButton(
                  icon: Icons.chevron_right,
                  onPressed: _scrollRight,
                  isDark: isDark,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _ScrollButton extends StatelessWidget {
  const _ScrollButton({
    required this.icon,
    required this.onPressed,
    required this.isDark,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final buttonSize = isMobile ? 36.0 : 48.0;
    final iconSize = isMobile ? 20.0 : 28.0;
    
    return Align(
      alignment: icon == Icons.chevron_left ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        width: buttonSize,
        height: buttonSize,
        margin: EdgeInsets.only(
          left: icon == Icons.chevron_left ? (isMobile ? 4 : 8) : 0,
          right: icon == Icons.chevron_right ? (isMobile ? 4 : 8) : 0,
        ),
        decoration: BoxDecoration(
          color: isDark
              ? ColorName.darkThemeCardBackground
              : Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: isMobile ? 8 : 12,
              offset: Offset(0, isMobile ? 2 : 4),
            ),
          ],
          border: Border.all(
            color: isDark
                ? ColorName.darkThemeBorderSoft
                : ColorName.borderSoft,
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(buttonSize / 2),
            child: Icon(
              icon,
              color: ColorName.primary,
              size: iconSize,
            ),
          ),
        ),
      ),
    );
  }
}
