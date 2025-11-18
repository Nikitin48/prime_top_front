import 'package:flutter/material.dart';
import 'package:prime_top_front/core/widgets/screen_wrapper.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ScreenWrapper(
      child: Center(
        child: Text('Здесь будет список ваших заказов'),
      ),
    );
  }
}


