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
  final _seriesIdController = TextEditingController();
  final _analysesBleskController = TextEditingController();
  final _analysesVyazkostController = TextEditingController();
  final _analysesDeltaEController = TextEditingController();
  final _analysesDeltaLController = TextEditingController();
  final _analysesDeltaAController = TextEditingController();
  final _analysesDeltaBController = TextEditingController();
  final _minBleskController = TextEditingController();
  final _maxBleskController = TextEditingController();
  final _minVyazkostController = TextEditingController();
  final _maxVyazkostController = TextEditingController();
  final _minDeltaEController = TextEditingController();
  final _maxDeltaEController = TextEditingController();
  final _minDeltaLController = TextEditingController();
  final _maxDeltaLController = TextEditingController();
  final _minDeltaAController = TextEditingController();
  final _maxDeltaAController = TextEditingController();
  final _minDeltaBController = TextEditingController();
  final _maxDeltaBController = TextEditingController();

  bool _includePublic = true;
  bool _personalOnly = false;

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
    _seriesIdController.dispose();
    _analysesBleskController.dispose();
    _analysesVyazkostController.dispose();
    _analysesDeltaEController.dispose();
    _analysesDeltaLController.dispose();
    _analysesDeltaAController.dispose();
    _analysesDeltaBController.dispose();
    _minBleskController.dispose();
    _maxBleskController.dispose();
    _minVyazkostController.dispose();
    _maxVyazkostController.dispose();
    _minDeltaEController.dispose();
    _maxDeltaEController.dispose();
    _minDeltaLController.dispose();
    _maxDeltaLController.dispose();
    _minDeltaAController.dispose();
    _maxDeltaAController.dispose();
    _minDeltaBController.dispose();
    _maxDeltaBController.dispose();
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
      seriesId: filters.seriesId,
      includePublic: filters.includePublic,
      personalOnly: filters.personalOnly,
      analysesBleskPri60Grad: filters.analysesBleskPri60Grad,
      analysesUslovnayaVyazkost: filters.analysesUslovnayaVyazkost,
      analysesDeltaE: filters.analysesDeltaE,
      analysesDeltaL: filters.analysesDeltaL,
      analysesDeltaA: filters.analysesDeltaA,
      analysesDeltaB: filters.analysesDeltaB,
      minAnalysesBleskPri60Grad: filters.minAnalysesBleskPri60Grad,
      maxAnalysesBleskPri60Grad: filters.maxAnalysesBleskPri60Grad,
      minAnalysesUslovnayaVyazkost: filters.minAnalysesUslovnayaVyazkost,
      maxAnalysesUslovnayaVyazkost: filters.maxAnalysesUslovnayaVyazkost,
      minAnalysesDeltaE: filters.minAnalysesDeltaE,
      maxAnalysesDeltaE: filters.maxAnalysesDeltaE,
      minAnalysesDeltaL: filters.minAnalysesDeltaL,
      maxAnalysesDeltaL: filters.maxAnalysesDeltaL,
      minAnalysesDeltaA: filters.minAnalysesDeltaA,
      maxAnalysesDeltaA: filters.maxAnalysesDeltaA,
      minAnalysesDeltaB: filters.minAnalysesDeltaB,
      maxAnalysesDeltaB: filters.maxAnalysesDeltaB,
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
      seriesId: _seriesIdController.text.trim().isEmpty
          ? null
          : int.tryParse(_seriesIdController.text.trim()),
      includePublic: _includePublic,
      personalOnly: _personalOnly,
      analysesBleskPri60Grad: _analysesBleskController.text.trim().isEmpty
          ? null
          : double.tryParse(_analysesBleskController.text.trim()),
      analysesUslovnayaVyazkost: _analysesVyazkostController.text.trim().isEmpty
          ? null
          : double.tryParse(_analysesVyazkostController.text.trim()),
      analysesDeltaE: _analysesDeltaEController.text.trim().isEmpty
          ? null
          : double.tryParse(_analysesDeltaEController.text.trim()),
      analysesDeltaL: _analysesDeltaLController.text.trim().isEmpty
          ? null
          : double.tryParse(_analysesDeltaLController.text.trim()),
      analysesDeltaA: _analysesDeltaAController.text.trim().isEmpty
          ? null
          : double.tryParse(_analysesDeltaAController.text.trim()),
      analysesDeltaB: _analysesDeltaBController.text.trim().isEmpty
          ? null
          : double.tryParse(_analysesDeltaBController.text.trim()),
      minAnalysesBleskPri60Grad: _minBleskController.text.trim().isEmpty
          ? null
          : double.tryParse(_minBleskController.text.trim()),
      maxAnalysesBleskPri60Grad: _maxBleskController.text.trim().isEmpty
          ? null
          : double.tryParse(_maxBleskController.text.trim()),
      minAnalysesUslovnayaVyazkost: _minVyazkostController.text.trim().isEmpty
          ? null
          : double.tryParse(_minVyazkostController.text.trim()),
      maxAnalysesUslovnayaVyazkost: _maxVyazkostController.text.trim().isEmpty
          ? null
          : double.tryParse(_maxVyazkostController.text.trim()),
      minAnalysesDeltaE: _minDeltaEController.text.trim().isEmpty
          ? null
          : double.tryParse(_minDeltaEController.text.trim()),
      maxAnalysesDeltaE: _maxDeltaEController.text.trim().isEmpty
          ? null
          : double.tryParse(_maxDeltaEController.text.trim()),
      minAnalysesDeltaL: _minDeltaLController.text.trim().isEmpty
          ? null
          : double.tryParse(_minDeltaLController.text.trim()),
      maxAnalysesDeltaL: _maxDeltaLController.text.trim().isEmpty
          ? null
          : double.tryParse(_maxDeltaLController.text.trim()),
      minAnalysesDeltaA: _minDeltaAController.text.trim().isEmpty
          ? null
          : double.tryParse(_minDeltaAController.text.trim()),
      maxAnalysesDeltaA: _maxDeltaAController.text.trim().isEmpty
          ? null
          : double.tryParse(_maxDeltaAController.text.trim()),
      minAnalysesDeltaB: _minDeltaBController.text.trim().isEmpty
          ? null
          : double.tryParse(_minDeltaBController.text.trim()),
      maxAnalysesDeltaB: _maxDeltaBController.text.trim().isEmpty
          ? null
          : double.tryParse(_maxDeltaBController.text.trim()),
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
    _seriesIdController.clear();
    _analysesBleskController.clear();
    _analysesVyazkostController.clear();
    _analysesDeltaEController.clear();
    _analysesDeltaLController.clear();
    _analysesDeltaAController.clear();
    _analysesDeltaBController.clear();
    _minBleskController.clear();
    _maxBleskController.clear();
    _minVyazkostController.clear();
    _maxVyazkostController.clear();
    _minDeltaEController.clear();
    _maxDeltaEController.clear();
    _minDeltaLController.clear();
    _maxDeltaLController.clear();
    _minDeltaAController.clear();
    _maxDeltaAController.clear();
    _minDeltaBController.clear();
    _maxDeltaBController.clear();
    setState(() {
      _includePublic = true;
      _personalOnly = false;
    });
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
                          if (state.response!.series.isNotEmpty) ...[
                            Builder(
                              builder: (context) {
                                final clientStocks = state.response!.series
                                    .where((s) => s.reservedForClient)
                                    .toList();
                                final publicStocks = state.response!.series
                                    .where((s) => !s.reservedForClient)
                                    .toList();
                                
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (clientStocks.isNotEmpty) ...[
                                      StockListSection(
                                        stocks: clientStocks,
                                        title: 'Остатки по моим заказам (${clientStocks.length})',
                                      ),
                                      const SizedBox(height: 32),
                          ],
                          StockListSection(
                                      stocks: publicStocks,
                                      title: 'Свободные остатки (${publicStocks.length})',
                                    ),
                                  ],
                                );
                              },
                            ),
                          ] else
                            _buildEmptyState(context, theme, isDark),
                          if (state.response!.totalCount > _pageSize) ...[
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
                label: 'ID серии',
                hint: 'Точный ID серии',
                icon: Icons.numbers_outlined,
                controller: _seriesIdController,
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          const SizedBox(height: 16),
          BlocBuilder<AuthCubit, AuthState>(
            builder: (context, authState) {
              if (authState.status == AuthStatus.authenticated && authState.user != null) {
                return Wrap(
                  spacing: 16,
                  runSpacing: 14,
                  children: [
                    FilterCheckbox(
                      label: 'Общие остатки',
                      value: _includePublic,
                      onChanged: (value) {
                        setState(() {
                          _includePublic = value ?? true;
                        });
                      },
                    ),
                    FilterCheckbox(
                      label: 'Только персональные',
                      value: _personalOnly,
                      onChanged: (value) {
                        setState(() {
                          _personalOnly = value ?? false;
                        });
                      },
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
          const SizedBox(height: 16),
          ExpansionTile(
            title: Text(
              'Фильтры по лабораторным анализам',
              style: theme.textTheme.titleSmall?.copyWith(
                color: isDark ? ColorName.darkThemeTextPrimary : ColorName.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            children: [
              const SizedBox(height: 8),
              Wrap(
                spacing: 16,
                runSpacing: 14,
                children: [
                  _FilterField(
                    label: 'Блеск при 60° (точное)',
                    hint: '85.5',
                    icon: Icons.brightness_6_outlined,
                    controller: _analysesBleskController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                  _FilterField(
                    label: 'Блеск при 60° (мин)',
                    hint: '80',
                    icon: Icons.arrow_downward_outlined,
                    controller: _minBleskController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                  _FilterField(
                    label: 'Блеск при 60° (макс)',
                    hint: '90',
                    icon: Icons.arrow_upward_outlined,
                    controller: _maxBleskController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                  _FilterField(
                    label: 'Условная вязкость (точное)',
                    hint: '45.2',
                    icon: Icons.water_drop_outlined,
                    controller: _analysesVyazkostController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                  _FilterField(
                    label: 'Условная вязкость (мин)',
                    hint: '40',
                    icon: Icons.arrow_downward_outlined,
                    controller: _minVyazkostController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                  _FilterField(
                    label: 'Условная вязкость (макс)',
                    hint: '50',
                    icon: Icons.arrow_upward_outlined,
                    controller: _maxVyazkostController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                  _FilterField(
                    label: 'Delta E (точное)',
                    hint: '2.3',
                    icon: Icons.colorize_outlined,
                    controller: _analysesDeltaEController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                  _FilterField(
                    label: 'Delta E (мин)',
                    hint: '1.0',
                    icon: Icons.arrow_downward_outlined,
                    controller: _minDeltaEController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                  _FilterField(
                    label: 'Delta E (макс)',
                    hint: '3.0',
                    icon: Icons.arrow_upward_outlined,
                    controller: _maxDeltaEController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                  _FilterField(
                    label: 'Delta L (точное)',
                    hint: '1.5',
                    icon: Icons.colorize_outlined,
                    controller: _analysesDeltaLController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                  _FilterField(
                    label: 'Delta L (мин)',
                    hint: '0.5',
                    icon: Icons.arrow_downward_outlined,
                    controller: _minDeltaLController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                  _FilterField(
                    label: 'Delta L (макс)',
                    hint: '2.5',
                    icon: Icons.arrow_upward_outlined,
                    controller: _maxDeltaLController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                  _FilterField(
                    label: 'Delta A (точное)',
                    hint: '0.8',
                    icon: Icons.colorize_outlined,
                    controller: _analysesDeltaAController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                  _FilterField(
                    label: 'Delta A (мин)',
                    hint: '0.0',
                    icon: Icons.arrow_downward_outlined,
                    controller: _minDeltaAController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                  _FilterField(
                    label: 'Delta A (макс)',
                    hint: '1.5',
                    icon: Icons.arrow_upward_outlined,
                    controller: _maxDeltaAController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                  _FilterField(
                    label: 'Delta B (точное)',
                    hint: '1.2',
                    icon: Icons.colorize_outlined,
                    controller: _analysesDeltaBController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                  _FilterField(
                    label: 'Delta B (мин)',
                    hint: '0.0',
                    icon: Icons.arrow_downward_outlined,
                    controller: _minDeltaBController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                  _FilterField(
                    label: 'Delta B (макс)',
                    hint: '2.0',
                    icon: Icons.arrow_upward_outlined,
                    controller: _maxDeltaBController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ],
              ),
              const SizedBox(height: 8),
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
    final totalCount = state.response!.totalCount;
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

  Widget _buildEmptyState(BuildContext context, ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? ColorName.darkThemeCardBackground : ColorName.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? ColorName.darkThemeBorderSoft : ColorName.borderSoft,
        ),
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
}

class FilterCheckbox extends StatelessWidget {
  const FilterCheckbox({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return CheckboxListTile(
      title: Text(
        label,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: isDark ? ColorName.darkThemeTextPrimary : ColorName.textPrimary,
        ),
      ),
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
      dense: true,
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
                  'Расширенная фильтрация по RAL, типу покрытия, сериям и лабораторным анализам. Быстрый доступ к остаткам по вашим заказам и свободным запасам.',
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
