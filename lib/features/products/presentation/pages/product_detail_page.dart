import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:prime_top_front/core/gen/colors.gen.dart';
import 'package:prime_top_front/features/products/application/cubit/product_detail_cubit.dart';
import 'package:prime_top_front/features/products/application/cubit/product_detail_state.dart';
import 'package:prime_top_front/features/products/presentation/widgets/product_info_section.dart';
import 'package:prime_top_front/features/products/presentation/widgets/series_list_section.dart';

class ProductDetailPage extends StatefulWidget {
  const ProductDetailPage({super.key, required this.productId});

  final int productId;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  void initState() {
    super.initState();
    // Отложим загрузку до завершения построения виджета
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ProductDetailCubit>().loadProductDetail(widget.productId);
      }
    });
  }

  @override
  void didUpdateWidget(ProductDetailPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Если productId изменился, загружаем новые данные
    if (oldWidget.productId != widget.productId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<ProductDetailCubit>().loadProductDetail(widget.productId);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return const _ProductDetailView();
  }
}

class _ProductDetailView extends StatelessWidget {
  const _ProductDetailView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<ProductDetailCubit, ProductDetailState>(
      builder: (context, state) {
        if (state.isLoading) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: const Padding(
                padding: EdgeInsets.all(32.0),
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        if (state.errorMessage != null) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
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
                        final productId = GoRouterState.of(context).pathParameters['productId'];
                        if (productId != null) {
                          context.read<ProductDetailCubit>().loadProductDetail(int.parse(productId));
                        }
                      },
                      child: const Text('Повторить'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (state.productDetail == null) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text(
                  'Продукт не найден',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: isDark
                        ? ColorName.darkThemeTextSecondary
                        : ColorName.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }

        final productDetail = state.productDetail!;
        final product = productDetail.product;

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Информация о продукте
                  ProductInfoSection(
                    product: product,
                    coatingType: product.coatingType,
                  ),
                  const SizedBox(height: 32),
                  // Список серий
                  SeriesListSection(series: productDetail.series),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

