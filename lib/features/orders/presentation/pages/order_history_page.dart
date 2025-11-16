import 'package:flutter/material.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('История заказов'),
      ),
      body: const Center(
        child: Text('Здесь будет история ваших заказов'),
      ),
    );
  }
}


