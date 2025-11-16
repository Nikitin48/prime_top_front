import 'package:flutter/material.dart';
import 'package:prime_top_front/core/gen/colors.gen.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white);
    final titleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600);
    return SizedBox(
      height: 250,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [ColorName.primary, ColorName.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          top: false,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Связаться с нами', style: titleStyle),
                    const SizedBox(height: 8),
                    Text('+7 (4742) 75-50-01', style: textStyle),
                    const SizedBox(height: 8),
                    Text('company@prime-top.ru', style: textStyle),
                    const SizedBox(height: 8),
                    Text(
                      '398516, Россия, Липецкая область, Липецкий муниципальный округ, село Косыревка, ул. Советская, д. 61А',
                      style: textStyle,
                    ),
                    const SizedBox(height: 16),
                    Text('Обособленное подразделение', style: titleStyle),
                    const SizedBox(height: 8),
                    Text('+7 (495) 646 28 24', style: textStyle),
                    const SizedBox(height: 8),
                    Text(
                      '119071, Россия, Москва, внутренний территориальный городской муниципальный округ Донской, ул. Орджоникидзе, д. 12, стр. 3',
                      style: textStyle,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


