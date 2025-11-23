import 'package:flutter/material.dart';
import '../../domain/entities/top_products.dart';

class TopProductsWidget extends StatelessWidget {
  const TopProductsWidget({
    super.key,
    required this.data,
  });

  final TopProducts data;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Топ продуктов',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  const TabBar(
                    tabs: [
                      Tab(text: 'По количеству'),
                      Tab(text: 'По выручке'),
                      Tab(text: 'По заказам'),
                    ],
                  ),
                  SizedBox(
                    height: 400,
                    child: TabBarView(
                      children: [
                        _buildProductsList(data.topByQuantity),
                        _buildProductsList(data.topByRevenue),
                        _buildProductsList(data.topByOrders),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsList(List<ProductStats> products) {
    if (products.isEmpty) {
      return const Center(
        child: Text('Нет данных'),
      );
    }

    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ListTile(
          leading: CircleAvatar(
            child: Text('${index + 1}'),
          ),
          title: Text(product.productName),
          subtitle: Text('${product.coatingType.name} (${product.coatingType.nomenclature})'),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${product.totalQuantity.toStringAsFixed(1)} шт.',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '${product.totalRevenue.toStringAsFixed(2)} руб.',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        );
      },
    );
  }
}

