import 'package:flutter/material.dart';

class ClientProfilePage extends StatelessWidget {
  const ClientProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль клиента'),
      ),
      body: const Center(
        child: Text('Здесь будут данные профиля и настройки'),
      ),
    );
  }
}


