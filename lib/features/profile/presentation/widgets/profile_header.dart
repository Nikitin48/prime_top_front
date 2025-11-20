import 'package:flutter/material.dart';
import 'package:prime_top_front/core/gen/colors.gen.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: ColorName.primary.withOpacity(0.12),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            Icons.person,
            size: 32,
            color: ColorName.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Профиль',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: isDark ? ColorName.darkThemeTextPrimary : ColorName.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Управление аккаунтом и организацией',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark ? ColorName.darkThemeTextSecondary : ColorName.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
