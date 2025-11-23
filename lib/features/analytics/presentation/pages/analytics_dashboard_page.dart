import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/xss_protection.dart';
import '../../../../core/widgets/screen_wrapper.dart';
import '../../application/cubit/analytics_cubit.dart';
import '../widgets/top_products_widget.dart';
import '../widgets/top_coating_types_chart.dart';
import '../widgets/filter_dialog.dart';

class AnalyticsDashboardPage extends StatefulWidget {
  const AnalyticsDashboardPage({super.key});

  @override
  State<AnalyticsDashboardPage> createState() => _AnalyticsDashboardPageState();
}

class _AnalyticsDashboardPageState extends State<AnalyticsDashboardPage> {
  @override
  void initState() {
    super.initState();
    // Загружаем данные при открытии страницы
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AnalyticsCubit>().loadAllData();
    });
  }

  Future<void> _showFilterDialog() async {
    final state = context.read<AnalyticsCubit>().state;
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => FilterDialog(
        dateFrom: state.dateFrom,
        dateTo: state.dateTo,
      ),
    );

    if (result != null && mounted) {
      context.read<AnalyticsCubit>().loadAllData(
            dateFrom: result['dateFrom'] as DateTime?,
            dateTo: result['dateTo'] as DateTime?,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      padding: EdgeInsets.zero,
      child: BlocBuilder<AnalyticsCubit, AnalyticsState>(
        builder: (context, state) {
          if (state.isLoading && state.topProducts == null && state.topCoatingTypes == null) {
            return const Padding(
              padding: EdgeInsets.only(top: 300),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (state.errorMessage != null && state.topProducts == null && state.topCoatingTypes == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Ошибка: ${XssProtection.sanitize(state.errorMessage)}',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<AnalyticsCubit>().loadAllData(),
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<AnalyticsCubit>().loadAllData(
                    dateFrom: state.dateFrom,
                    dateTo: state.dateTo,
                  );
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          'Аналитика',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.filter_list),
                        onPressed: _showFilterDialog,
                        tooltip: 'Фильтры',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (state.topCoatingTypes != null) ...[
                    TopCoatingTypesChart(data: state.topCoatingTypes!),
                    const SizedBox(height: 16),
                  ],
                  if (state.topProducts != null) ...[
                    TopProductsWidget(data: state.topProducts!),
                    const SizedBox(height: 16),
                  ],
                  if (state.isLoading)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

