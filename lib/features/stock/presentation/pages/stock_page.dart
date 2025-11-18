import 'package:flutter/material.dart';
import 'package:prime_top_front/core/widgets/screen_wrapper.dart';

class StockPage extends StatelessWidget {
  const StockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScreenWrapper(
      child: Center(
        child: Text('Здесь будут остатки товаров на складе'),
      ),
    );
  }
}


