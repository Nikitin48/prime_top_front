import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:prime_top_front/core/gen/colors.gen.dart';
import 'package:prime_top_front/features/home/application/cubit/top_products_cubit.dart';
import 'package:prime_top_front/features/home/application/cubit/top_products_state.dart';
import 'package:prime_top_front/features/home/domain/entities/popular_product.dart';
import 'package:prime_top_front/features/products/presentation/widgets/product_card.dart';

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

    return BlocBuilder<TopProductsCubit, TopProductsState>(
      builder: (context, state) {
        if (state.isLoading) {
          return _buildLoadingState(context, theme, isDark);
        }

        if (state.errorMessage != null) {
          return _buildErrorState(context, theme, isDark, state.errorMessage!);
        }

        if (state.products.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32).copyWith(top: 64),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(context, theme),
                const SizedBox(height: 24),
                _ProductsScrollSection(products: state.products),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(left: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Популярные товары',
            style: theme.textTheme.displaySmall?.copyWith(
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
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32).copyWith(top: 64),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: Column(
          children: [
            _buildSectionHeader(context, theme),
            const SizedBox(height: 32),
            const Center(
              child: Padding(
                padding: EdgeInsets.all(64.0),
                child: CircularProgressIndicator(),
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
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32).copyWith(top: 64),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: Column(
          children: [
            _buildSectionHeader(context, theme),
            const SizedBox(height: 32),
            Center(
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
  double _cardWidth = 0;

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
    if (!_scrollController.hasClients || _cardWidth == 0) return;
    
    final currentPosition = _scrollController.position.pixels;
    final targetPosition = (currentPosition - _cardWidth).clamp(
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
    if (!_scrollController.hasClients || _cardWidth == 0) return;
    
    final currentPosition = _scrollController.position.pixels;
    final targetPosition = (currentPosition + _cardWidth).clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );
    
    _scrollController.animateTo(
      targetPosition,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
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
        final cardWidth = (constraints.maxWidth - 60) / 4;
        final cardWidthWithSpacing = cardWidth + 20;
        
        if (_cardWidth != cardWidthWithSpacing) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _cardWidth = cardWidthWithSpacing;
            });
            _updateButtonVisibility();
          });
        }
        
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
              padding: EdgeInsets.symmetric(
                horizontal: _showLeftButton || _showRightButton ? 48 : 0,
              ),
              child: SizedBox(
                height: _getCardHeight(cardWidth),
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.products.length,
                  itemExtent: cardWidthWithSpacing,
                  itemBuilder: (context, index) {
                    final popularProduct = widget.products[index];
                    return Padding(
                      padding: EdgeInsets.only(
                        right: index < widget.products.length - 1 ? 20 : 0,
                      ),
                      child: SizedBox(
                        width: cardWidth,
                        child: ProductCard(
                          product: popularProduct.product,
                          showPrice: true,
                          showPopularity: true,
                          totalOrdered: popularProduct.totalOrdered,
                          cardStyle: ProductCardStyle.featured,
                          onTap: () {
                            context.go('/products/${popularProduct.product.id}');
                          },
                        ),
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

  double _getCardHeight(double cardWidth) {
    return cardWidth / 0.75 - 150;
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
    return Align(
      alignment: icon == Icons.chevron_left ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        width: 48,
        height: 48,
        margin: EdgeInsets.only(
          left: icon == Icons.chevron_left ? 8 : 0,
          right: icon == Icons.chevron_right ? 8 : 0,
        ),
        decoration: BoxDecoration(
          color: isDark
              ? ColorName.darkThemeCardBackground
              : Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
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
            borderRadius: BorderRadius.circular(24),
            child: Icon(
              icon,
              color: ColorName.primary,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}

