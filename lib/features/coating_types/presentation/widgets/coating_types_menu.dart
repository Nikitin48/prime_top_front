import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_top_front/core/gen/colors.gen.dart';
import 'package:prime_top_front/features/coating_types/application/cubit/coating_types_cubit.dart';
import 'package:prime_top_front/features/coating_types/application/cubit/coating_types_state.dart';
import 'package:prime_top_front/features/coating_types/domain/entities/coating_type.dart';
import 'package:prime_top_front/features/products/application/cubit/products_cubit.dart';
import 'package:prime_top_front/features/products/presentation/widgets/products_column.dart';

class CoatingTypesMenu extends StatefulWidget {
  const CoatingTypesMenu({
    super.key,
    required this.onClose,
  });

  final VoidCallback onClose;

  @override
  State<CoatingTypesMenu> createState() => _CoatingTypesMenuState();
}

class _CoatingTypesMenuState extends State<CoatingTypesMenu> {
  int? _selectedIndex;
  int? _hoveredIndex;
  Timer? _hoverTimer;

  @override
  void initState() {
    super.initState();
    context.read<CoatingTypesCubit>().loadCoatingTypes(sort: 'nomenclature');
  }

  @override
  void dispose() {
    _hoverTimer?.cancel();
    super.dispose();
  }

  void _onItemTap(CoatingType coatingType, int index) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    
    if (isMobile) {
      _hoverTimer?.cancel();
      if (_selectedIndex == index) {
        setState(() {
          _selectedIndex = null;
        });
        context.read<ProductsCubit>().clearProducts();
      } else {
        setState(() {
          _selectedIndex = index;
        });
        context.read<ProductsCubit>().loadProductsByCoatingType(
          coatingType.id,
          limit: 10,
          offset: 0,
        );
      }
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _onItemHover(CoatingType coatingType, int index, bool isHovered) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    
    if (isMobile) return;
    
    _hoverTimer?.cancel();

    if (isHovered) {
      setState(() {
        _hoveredIndex = index;
      });

      _hoverTimer = Timer(const Duration(milliseconds: 500), () {
        if (mounted && _hoveredIndex == index) {
          context.read<ProductsCubit>().loadProductsByCoatingType(
            coatingType.id,
            limit: 10,
            offset: 0,
          );
        }
      });
    } else {
      setState(() {
        _hoveredIndex = null;
      });
      context.read<ProductsCubit>().clearProducts();
    }
  }

  void _onProductsColumnHover(bool isHovered) {
    if (!isHovered && _hoveredIndex != null) {
      _hoverTimer?.cancel();
      setState(() {
        _hoveredIndex = null;
      });
      context.read<ProductsCubit>().clearProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isLargeScreen = screenWidth >= 1024;

    return GestureDetector(
      onTap: widget.onClose,
      child: Container(
        color: Colors.black.withOpacity(0.3),
          child: GestureDetector(
          onTap: () {},
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: isLargeScreen ? MainAxisSize.min : MainAxisSize.max,
            children: [
              isLargeScreen
                  ? Container(
                      width: 320,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: isDark ? ColorName.darkThemeBackground : ColorName.background,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: _buildCoatingTypesList(context, theme, isDark, isMobile),
                    )
                  : Expanded(
                      child: Container(
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: isDark ? ColorName.darkThemeBackground : ColorName.background,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: _buildCoatingTypesList(context, theme, isDark, isMobile),
                      ),
                    ),
              isLargeScreen
                  ? Container(
                      width: 400,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: isDark ? ColorName.darkThemeBackground : ColorName.background,
                        border: Border(
                          left: BorderSide(
                            color: isDark
                                ? ColorName.darkThemeBorderSoft
                                : ColorName.borderSoft,
                            width: 1,
                          ),
                        ),
                      ),
                      child: (isMobile ? _selectedIndex != null : _hoveredIndex != null)
                          ? MouseRegion(
                              onEnter: isMobile ? null : (_) => _onProductsColumnHover(true),
                              onExit: isMobile ? null : (_) => _onProductsColumnHover(false),
                              child: const ProductsColumn(),
                            )
                          : Center(
                              child: Padding(
                                padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
                                child: Text(
                                  'Выберите тип покрытия',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: isDark
                                        ? ColorName.darkThemeTextSecondary
                                        : ColorName.textSecondary,
                                    fontSize: isMobile ? 14 : null,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                    )
                  : Expanded(
                      child: Container(
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: isDark ? ColorName.darkThemeBackground : ColorName.background,
                          border: Border(
                            left: BorderSide(
                              color: isDark
                                  ? ColorName.darkThemeBorderSoft
                                  : ColorName.borderSoft,
                              width: 1,
                            ),
                          ),
                        ),
                        child: (isMobile ? _selectedIndex != null : _hoveredIndex != null)
                            ? MouseRegion(
                                onEnter: isMobile ? null : (_) => _onProductsColumnHover(true),
                                onExit: isMobile ? null : (_) => _onProductsColumnHover(false),
                                child: const ProductsColumn(),
                              )
                            : Center(
                                child: Padding(
                                  padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
                                  child: Text(
                                    'Выберите тип покрытия',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: isDark
                                          ? ColorName.darkThemeTextSecondary
                                          : ColorName.textSecondary,
                                      fontSize: isMobile ? 14 : null,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoatingTypesList(BuildContext context, ThemeData theme, bool isDark, bool isMobile) {
    return BlocBuilder<CoatingTypesCubit, CoatingTypesState>(
      builder: (context, state) {
        if (state.isLoading) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
              child: const CircularProgressIndicator(),
            ),
          );
        }

        if (state.errorMessage != null) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: isMobile ? 36 : 48,
                    color: ColorName.danger,
                  ),
                  SizedBox(height: isMobile ? 12 : 16),
                  Text(
                    state.errorMessage!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: ColorName.danger,
                      fontSize: isMobile ? 14 : null,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: isMobile ? 12 : 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CoatingTypesCubit>().loadCoatingTypes(sort: 'nomenclature');
                    },
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state.coatingTypes.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
              child: Text(
                'Типы покрытий не найдены',
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

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: state.coatingTypes.length,
          itemBuilder: (context, index) {
            final coatingType = state.coatingTypes[index];
            final isSelected = _selectedIndex == index;
            final isHovered = _hoveredIndex == index;
            final shouldHighlight = isMobile ? isSelected : (isSelected || isHovered);

            return Material(
              color: Colors.transparent,
              child: MouseRegion(
                onEnter: isMobile ? null : (_) => _onItemHover(coatingType, index, true),
                onExit: isMobile ? null : (_) => _onItemHover(coatingType, index, false),
                child: InkWell(
                  onTap: () => _onItemTap(coatingType, index),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 16 : 24,
                      vertical: isMobile ? 12 : 16,
                    ),
                    decoration: BoxDecoration(
                      color: shouldHighlight
                          ? (isDark
                              ? ColorName.darkThemeBackgroundSecondary
                              : ColorName.backgroundSecondary)
                          : Colors.transparent,
                      border: Border(
                        left: BorderSide(
                          color: shouldHighlight
                              ? ColorName.primary
                              : Colors.transparent,
                          width: isMobile ? 2 : 3,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${coatingType.name} (${coatingType.nomenclature})',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: shouldHighlight
                                  ? ColorName.primary
                                  : (isDark
                                      ? ColorName.darkThemeTextPrimary
                                      : ColorName.textPrimary),
                              fontWeight: shouldHighlight
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                              fontSize: isMobile ? 14 : null,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (shouldHighlight)
                          Icon(
                            Icons.arrow_forward_ios,
                            size: isMobile ? 14 : 16,
                            color: ColorName.primary,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

