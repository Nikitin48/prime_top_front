import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_top_front/features/products/application/cubit/products_cubit.dart';
import 'package:prime_top_front/features/products/presentation/widgets/products_list_widget.dart';

class ProductsByCoatingTypePage extends StatefulWidget {
  const ProductsByCoatingTypePage({
    super.key,
    required this.coatingTypeId,
    this.coatingTypeName,
  });

  final int coatingTypeId;
  final String? coatingTypeName;

  @override
  State<ProductsByCoatingTypePage> createState() => _ProductsByCoatingTypePageState();
}

class _ProductsByCoatingTypePageState extends State<ProductsByCoatingTypePage> {
  static const int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final cubit = context.read<ProductsCubit>();
        if (cubit.state.selectedCoatingTypeId != widget.coatingTypeId) {
          cubit.clearProducts();
        }
      }
    });
  }

  void _loadProducts(int page, int pageSize) {
    context.read<ProductsCubit>().loadProductsByCoatingType(
      widget.coatingTypeId,
      limit: pageSize,
      offset: page * pageSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProductsListWidget(
      title: widget.coatingTypeName ?? 'Товары',
      onLoadProducts: _loadProducts,
      pageSize: _pageSize,
    );
  }
}
