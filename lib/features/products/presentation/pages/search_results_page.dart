import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_top_front/features/products/application/cubit/products_cubit.dart';
import 'package:prime_top_front/features/products/presentation/widgets/products_list_widget.dart';

class SearchResultsPage extends StatefulWidget {
  const SearchResultsPage({
    super.key,
    required this.query,
  });

  final String query;

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final cubit = context.read<ProductsCubit>();
        if (cubit.state.searchQuery != widget.query) {
          cubit.clearProducts();
        }
      }
    });
  }

  void _loadProducts(int page, int pageSize) {
    context.read<ProductsCubit>().searchProducts(
      widget.query,
      limit: pageSize,
      offset: page * pageSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProductsListWidget(
      title: 'Результаты поиска',
      subtitle: 'По запросу: "${widget.query}"',
      onLoadProducts: _loadProducts,
    );
  }
}
