import 'package:flutter/material.dart';
import 'package:prime_top_front/core/widgets/screen_wrapper.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: const Text(''),
        ),
      ),
    );
  }
}


