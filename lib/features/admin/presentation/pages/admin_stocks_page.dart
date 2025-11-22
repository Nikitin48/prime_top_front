import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_top_front/core/gen/colors.gen.dart';
import 'package:prime_top_front/core/widgets/pagination_controls.dart';
import 'package:prime_top_front/core/widgets/screen_wrapper.dart';
import 'package:prime_top_front/features/admin/application/cubit/admin_stocks_cubit.dart';
import 'package:prime_top_front/features/admin/domain/entities/admin_stock.dart';

class AdminStocksPage extends StatefulWidget {
  const AdminStocksPage({super.key});

  @override
  State<AdminStocksPage> createState() => _AdminStocksPageState();
}

class _AdminStocksPageState extends State<AdminStocksPage> {
  int _currentPage = 0;
  static const int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    _loadStocks();
  }

  void _loadStocks() {
    context.read<AdminStocksCubit>().loadStocks(
          limit: _pageSize,
          offset: _currentPage * _pageSize,
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ScreenWrapper(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: BlocBuilder<AdminStocksCubit, AdminStocksState>(
        builder: (context, state) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: constraints.maxWidth > 1400 ? 1400 : constraints.maxWidth,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context, theme, isDark),
                        const SizedBox(height: 24),
                        if (state.status == AdminStocksStatus.loading)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        else if (state.status == AdminStocksStatus.failure)
                          _buildError(context, theme, isDark, state.errorMessage ?? 'Ошибка загрузки остатков')
                        else if (state.status == AdminStocksStatus.success)
                          _buildStocksTable(context, theme, isDark, state.stocks),
                        if (state.totalCount > _pageSize) ...[
                          const SizedBox(height: 24),
                          _buildPagination(context, theme, isDark, state),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme, bool isDark) {
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
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Управление остатками',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: isDark ? ColorName.darkThemeTextPrimary : ColorName.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Редактирование остатков на складе',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: isDark ? ColorName.darkThemeTextSecondary : ColorName.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.inventory_2_outlined,
            size: 32,
            color: isDark ? ColorName.darkThemeTextSecondary : ColorName.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, ThemeData theme, bool isDark, String message) {
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
            onPressed: _loadStocks,
            child: const Text('Повторить'),
          ),
        ],
      ),
    );
  }

  Widget _buildStocksTable(BuildContext context, ThemeData theme, bool isDark, List<AdminStock> stocks) {
    if (stocks.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: isDark ? ColorName.darkThemeCardBackground : ColorName.cardBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            'Остатки не найдены',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: isDark ? ColorName.darkThemeTextSecondary : ColorName.textSecondary,
            ),
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;
        
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: isDark ? ColorName.darkThemeCardBackground : ColorName.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDark ? ColorName.darkThemeBorderSoft : ColorName.borderSoft),
          ),
          child: isWide
              ? DataTable(
                  headingRowColor: WidgetStateProperty.all(
                    isDark ? ColorName.darkThemeBackgroundSecondary : ColorName.backgroundSecondary,
                  ),
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Серия')),
                    DataColumn(label: Text('Продукт')),
                    DataColumn(label: Text('Клиент')),
                    DataColumn(label: Text('Количество')),
                    DataColumn(label: Text('Обновлено')),
                    DataColumn(label: Text('Действия')),
                  ],
                  rows: stocks.map((stock) => _buildStockRow(context, theme, isDark, stock)).toList(),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(
                      isDark ? ColorName.darkThemeBackgroundSecondary : ColorName.backgroundSecondary,
                    ),
                    columns: const [
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Серия')),
                      DataColumn(label: Text('Продукт')),
                      DataColumn(label: Text('Клиент')),
                      DataColumn(label: Text('Количество')),
                      DataColumn(label: Text('Обновлено')),
                      DataColumn(label: Text('Действия')),
                    ],
                    rows: stocks.map((stock) => _buildStockRow(context, theme, isDark, stock)).toList(),
                  ),
                ),
        );
      },
    );
  }

  DataRow _buildStockRow(BuildContext context, ThemeData theme, bool isDark, AdminStock stock) {
    return DataRow(
      cells: [
        DataCell(Text('${stock.id}')),
        DataCell(Text(stock.series.name ?? '-')),
        DataCell(Text(stock.series.product?.name ?? '-')),
        DataCell(Text(stock.client?.name ?? 'Общедоступный')),
        DataCell(Text(stock.quantity.toString())),
        DataCell(Text(
          '${stock.updatedAt.day}.${stock.updatedAt.month}.${stock.updatedAt.year}',
        )),
        DataCell(
          IconButton(
            icon: const Icon(Icons.delete_outline),
            color: ColorName.danger,
            onPressed: () => _showDeleteDialog(context, stock),
          ),
        ),
      ],
    );
  }

  Widget _buildPagination(BuildContext context, ThemeData theme, bool isDark, AdminStocksState state) {
    final totalCount = state.totalCount;
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

  void _showDeleteDialog(BuildContext context, AdminStock stock) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить остаток?'),
        content: Text('Вы уверены, что хотите удалить остаток #${stock.id}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () async {
              try {
                final cubit = context.read<AdminStocksCubit>();
                const pageSize = 20;
                const currentPage = 0;
                await cubit.deleteStock(
                  stock.id,
                  limit: pageSize,
                  offset: currentPage * pageSize,
                );
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              } catch (e) {
                if (!e.toString().contains('cancel') && !e.toString().contains('Cancel')) {
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: ColorName.danger),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }
}
