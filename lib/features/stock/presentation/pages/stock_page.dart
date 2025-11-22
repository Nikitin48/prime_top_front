import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_top_front/core/gen/colors.gen.dart';
import 'package:prime_top_front/core/widgets/pagination_controls.dart';
import 'package:prime_top_front/core/widgets/screen_wrapper.dart';
import 'package:prime_top_front/features/auth/application/cubit/auth_cubit.dart';
import 'package:prime_top_front/features/stock/application/cubit/stock_cubit.dart';
import 'package:prime_top_front/features/stock/presentation/widgets/stock_list_section.dart';

class StockPage extends StatefulWidget {
  const StockPage({super.key});

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  final _colorController = TextEditingController();
  final _coatingTypeController = TextEditingController();
  final _seriesController = TextEditingController();
  final _minQuantityController = TextEditingController();

  int _currentPage = 0;
  static const int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    _loadStocks();
  }

  @override
  void dispose() {
    _colorController.dispose();
    _coatingTypeController.dispose();
    _seriesController.dispose();
    _minQuantityController.dispose();
    super.dispose();
  }

  void _loadStocks() {
    final authState = context.read<AuthCubit>().state;
    final clientId = authState.status == AuthStatus.authenticated && authState.user != null
        ? int.tryParse(authState.user!.client.id)
        : null;

    final cubit = context.read<StockCubit>();
    final filters = cubit.state.filters;

    cubit.loadStocks(
      clientId: clientId,
      color: filters.color?.isEmpty ?? true ? null : filters.color,
      coatingType: filters.coatingType?.isEmpty ?? true ? null : filters.coatingType,
      series: filters.series?.isEmpty ?? true ? null : filters.series,
      minQuantity: filters.minQuantity,
      limit: _pageSize,
      offset: _currentPage * _pageSize,
    );
  }

  void _applyFilters() {
    final cubit = context.read<StockCubit>();
    cubit.updateFilters(
      color: _colorController.text.trim().isEmpty ? null : _colorController.text.trim(),
      coatingType: _coatingTypeController.text.trim().isEmpty
          ? null
          : _coatingTypeController.text.trim(),
      series: _seriesController.text.trim().isEmpty ? null : _seriesController.text.trim(),
      minQuantity: _minQuantityController.text.trim().isEmpty
          ? null
          : double.tryParse(_minQuantityController.text.trim()),
    );
    setState(() {
      _currentPage = 0;
    });
    _loadStocks();
  }

  void _resetFilters() {
    _colorController.clear();
    _coatingTypeController.clear();
    _seriesController.clear();
    _minQuantityController.clear();
    context.read<StockCubit>().resetFilters();
    setState(() {
      _currentPage = 0;
    });
    _loadStocks();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ScreenWrapper(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: BlocBuilder<StockCubit, StockState>(
        builder: (context, state) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1280),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _StockHero(isDark: isDark, theme: theme),
                    const SizedBox(height: 16),
                    _buildFiltersSection(context, theme, isDark),
                    const SizedBox(height: 24),
                    if (state.status == StockStatus.loading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else if (state.status == StockStatus.failure)
                      _ErrorBlock(
                        theme: theme,
                        isDark: isDark,
                        message: state.errorMessage ?? 'Не удалось загрузить остатки',
                        onRetry: _loadStocks,
                      )
                    else if (state.status == StockStatus.success && state.response != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (state.response!.clientStocks != null &&
                              state.response!.clientStocks!.results.isNotEmpty) ...[
                            StockListSection(
                              stocks: state.response!.clientStocks!.results,
                              title:
                                  'Остатки по моим заказам (${state.response!.clientStocks!.count})',
                            ),
                            const SizedBox(height: 32),
                          ],
                          StockListSection(
                            stocks: state.response!.publicStocks.results,
                            title: 'Свободные остатки (${state.response!.publicStocks.count})',
                          ),
                          if (state.response!.publicStocks.totalCount > _pageSize) ...[
                            const SizedBox(height: 24),
                            _buildPagination(context, theme, isDark, state),
                          ],
                        ],
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFiltersSection(
    BuildContext context,
    ThemeData theme,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? ColorName.darkThemeCardBackground : ColorName.cardBackground,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? ColorName.darkThemeBorderSoft : ColorName.borderSoft,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 22,
                  offset: const Offset(0, 14),
                  spreadRadius: -10,
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Фильтр остатков',
            style: theme.textTheme.titleMedium?.copyWith(
              color: isDark ? ColorName.darkThemeTextPrimary : ColorName.textPrimary,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 14,
            children: [
              _FilterField(
                label: 'Цвет (RAL)',
                hint: 'Например, 9016',
                icon: Icons.palette_outlined,
                controller: _colorController,
              ),
              _FilterField(
                label: 'Тип покрытия',
                hint: 'Полиэфир, ПУ, ПВДФ...',
                icon: Icons.layers_outlined,
                controller: _coatingTypeController,
              ),
              _FilterField(
                label: 'Серия',
                hint: 'Код серии или партия',
                icon: Icons.qr_code_2_outlined,
                controller: _seriesController,
              ),
              _FilterField(
                label: 'Мин. количество',
                hint: '0.0',
                icon: Icons.inventory_2_outlined,
                controller: _minQuantityController,
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Divider(
            color: isDark ? ColorName.darkThemeBorderSoft : ColorName.borderSoft,
            height: 24,
          ),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: _applyFilters,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.tune, size: 18),
                      SizedBox(width: 8),
                      Text('Применить фильтр'),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: _resetFilters,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(
                    color: isDark ? ColorName.darkThemeBorderSoft : ColorName.borderSoft,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.refresh, size: 18),
                    SizedBox(width: 8),
                    Text('Сбросить'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPagination(
    BuildContext context,
    ThemeData theme,
    bool isDark,
    StockState state,
  ) {
    final totalCount = state.response!.publicStocks.totalCount;
    final totalPages = (totalCount / _pageSize).ceil();

    return PaginationControls(
      currentPage: _currentPage,
      totalPages: totalPages,
      pageSize: _pageSize,
      totalCount: totalCount,
      onPreviousPage: _currentPage > 0
          ? () {
              setState(() {
                _currentPage--;
              });
              _loadStocks();
            }
          : null,
      onNextPage: _currentPage < totalPages - 1
          ? () {
              setState(() {
                _currentPage++;
              });
              _loadStocks();
            }
          : null,
    );
  }
}

class _FilterField extends StatelessWidget {
  const _FilterField({
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    this.keyboardType,
  });

  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 260, maxWidth: 360),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(
            icon,
            color: isDark ? ColorName.darkThemeTextSecondary : ColorName.textSecondary,
          ),
          filled: true,
          fillColor:
              isDark ? ColorName.darkThemeBackgroundSecondary : ColorName.backgroundSecondary,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isDark ? ColorName.darkThemeBorderSoft : ColorName.borderSoft,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isDark ? ColorName.darkThemeBorderSoft : ColorName.borderSoft,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isDark ? ColorName.darkThemePrimary : ColorName.primary,
              width: 1.6,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        ),
      ),
    );
  }
}

class _StockHero extends StatelessWidget {
  const _StockHero({required this.isDark, required this.theme});

  final bool isDark;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [ColorName.darkThemeBackgroundSecondary, ColorName.darkThemeCardBackground]
              : [ColorName.primary.withOpacity(0.08), ColorName.secondary.withOpacity(0.08)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isDark ? ColorName.darkThemeBorderSoft : ColorName.borderSoft),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 14),
                  spreadRadius: -8,
                ),
              ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Остатки на складе',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: isDark ? ColorName.darkThemeTextPrimary : ColorName.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Фильтруйте по RAL, типу покрытия, серии и минимальному объёму. Быстрый доступ к остаткам по вашим заказам и свободным запасам.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: isDark ? ColorName.darkThemeTextSecondary : ColorName.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Icon(
            Icons.inventory_outlined,
            size: 32,
            color: isDark ? ColorName.darkThemeTextSecondary : ColorName.primary,
          ),
        ],
      ),
    );
  }
}

class _ErrorBlock extends StatelessWidget {
  const _ErrorBlock({
    required this.theme,
    required this.isDark,
    required this.message,
    required this.onRetry,
  });

  final ThemeData theme;
  final bool isDark;
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? ColorName.darkThemeCardBackground : ColorName.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorName.danger),
      ),
      child: Column(
        children: [
          Text(
            'Ошибка загрузки остатков',
            style: theme.textTheme.titleMedium?.copyWith(
              color: ColorName.danger,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark ? ColorName.darkThemeTextSecondary : ColorName.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Повторить'),
          ),
        ],
      ),
    );
  }
}
