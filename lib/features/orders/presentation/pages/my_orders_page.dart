import 'package:flutter/material.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои заказы'),
      ),
      body: const Center(
        child: Text('Здесь будет список ваших заказов'),
      ),
    );
  }
}


