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
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemHover(CoatingType coatingType, int index, bool isHovered) {
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

    return GestureDetector(
      onTap: widget.onClose,
      child: Container(
        color: Colors.black.withOpacity(0.3),
          child: GestureDetector(
          onTap: () {},
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
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
                child: BlocBuilder<CoatingTypesCubit, CoatingTypesState>(
              builder: (context, state) {
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
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: ColorName.danger,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
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
                      padding: const EdgeInsets.all(32.0),
                      child: Text(
                        'Типы покрытий не найдены',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: isDark
                              ? ColorName.darkThemeTextSecondary
                              : ColorName.textSecondary,
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

                    return Material(
                      color: Colors.transparent,
                      child: MouseRegion(
                        onEnter: (_) => _onItemHover(coatingType, index, true),
                        child: InkWell(
                          onTap: () => _onItemTap(coatingType, index),
                          child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected || isHovered
                              ? (isDark
                                  ? ColorName.darkThemeBackgroundSecondary
                                  : ColorName.backgroundSecondary)
                              : Colors.transparent,
                          border: Border(
                            left: BorderSide(
                              color: isSelected || isHovered
                                  ? ColorName.primary
                                  : Colors.transparent,
                              width: 3,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${coatingType.name} (${coatingType.nomenclature})',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: isSelected
                                      ? ColorName.primary
                                      : (isDark
                                          ? ColorName.darkThemeTextPrimary
                                          : ColorName.textPrimary),
                                  fontWeight: isSelected
                                      ? FontWeight.w500
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                            if (isSelected || isHovered)
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
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
            ),
              ),
              if (_hoveredIndex != null)
                MouseRegion(
                  onEnter: (_) => _onProductsColumnHover(true),
                  onExit: (_) => _onProductsColumnHover(false),
                  child: const ProductsColumn(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

