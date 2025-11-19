import 'package:flutter/material.dart';
import 'package:prime_top_front/core/gen/colors.gen.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white);
    final titleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600);
    return Container(
      width: double.infinity,
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
                  Text('Контакты производства', style: titleStyle),
                  const SizedBox(height: 8),
                  Text('+7 (4742) 75-50-01', style: textStyle),
                  const SizedBox(height: 8),
                  Text('company@prime-top.ru', style: textStyle),
                  const SizedBox(height: 8),
                  Text(
                    '398516, Россия, Липецкая область, ОЭЗ «Липецк», промышленная зона НЛМК, ул. Промышленная, д. 61Б',
                    style: textStyle,
                  ),
                  const SizedBox(height: 16),
                  Text('Офис продаж', style: titleStyle),
                  const SizedBox(height: 8),
                  Text('+7 (495) 646-28-24', style: textStyle),
                  const SizedBox(height: 8),
                  Text(
                    '119071, Россия, Москва, проспект Вернадского, д. 12, стр. 3 (НДЦ «Вернадский»)',
                    style: textStyle,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
