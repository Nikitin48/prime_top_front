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
    final clientId = authState.status == AuthStatus.authenticated &&
            authState.user != null
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
      series: _seriesController.text.trim().isEmpty
          ? null
          : _seriesController.text.trim(),
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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: BlocBuilder<StockCubit, StockState>(
        builder: (context, state) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(
                  'Остатки товаров',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: isDark
                        ? ColorName.darkThemeTextPrimary
                        : ColorName.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
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
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isDark
                          ? ColorName.darkThemeCardBackground
                          : ColorName.cardBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: ColorName.danger,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Ошибка при загрузке остатков',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: ColorName.danger,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.errorMessage ?? 'Неизвестная ошибка',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isDark
                                ? ColorName.darkThemeTextSecondary
                                : ColorName.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadStocks,
                          child: const Text('Повторить'),
                        ),
                      ],
                    ),
                  )
                else if (state.status == StockStatus.success &&
                    state.response != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (state.response!.clientStocks != null &&
                          state.response!.clientStocks!.results.isNotEmpty) ...[
                        StockListSection(
                          stocks: state.response!.clientStocks!.results,
                          title:
                              'Персональные остатки (${state.response!.clientStocks!.count})',
                        ),
                        const SizedBox(height: 32),
                      ],
                      StockListSection(
                        stocks: state.response!.publicStocks.results,
                        title: 'Общедоступные остатки (${state.response!.publicStocks.count})',
                      ),
                      if (state.response!.publicStocks.totalCount > _pageSize) ...[
                        const SizedBox(height: 32),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Фильтры',
            style: theme.textTheme.titleMedium?.copyWith(
              color: isDark
                  ? ColorName.darkThemeTextPrimary
                  : ColorName.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _colorController,
                  decoration: InputDecoration(
                    labelText: 'Цвет',
                    hintText: 'RAL код или название',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _coatingTypeController,
                  decoration: InputDecoration(
                    labelText: 'Тип покрытия',
                    hintText: 'Название или номенклатура',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _seriesController,
                  decoration: InputDecoration(
                    labelText: 'Серия',
                    hintText: 'ID или название серии',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextField(
                  controller: _minQuantityController,
                  decoration: InputDecoration(
                    labelText: 'Мин. количество',
                    hintText: '0.0',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _applyFilters,
                  child: const Text('Применить фильтры'),
                ),
              ),
              const SizedBox(width: 16),
              OutlinedButton(
                onPressed: _resetFilters,
                child: const Text('Сбросить'),
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