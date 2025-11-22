import 'package:flutter/material.dart';
import 'package:prime_top_front/core/gen/colors.gen.dart';

class UnauthorizedMessage extends StatelessWidget {
  const UnauthorizedMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.person_off,
                size: 64,
                color: isDark ? ColorName.darkThemeTextSecondary : ColorName.textSecondary,
              ),
              const SizedBox(height: 16),
              Text(
                'Пользователь не авторизован',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: isDark ? ColorName.darkThemeTextSecondary : ColorName.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
