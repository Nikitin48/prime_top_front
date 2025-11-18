import 'package:flutter/material.dart';
import 'package:prime_top_front/core/gen/colors.gen.dart';
import 'package:prime_top_front/features/auth/domain/entities/client.dart';
import 'package:prime_top_front/features/profile/presentation/widgets/profile_info_row.dart';

class ClientInfoCard extends StatelessWidget {
  const ClientInfoCard({
    super.key,
    required this.client,
  });

  final Client client;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? ColorName.darkThemeCardBackground : ColorName.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? ColorName.darkThemeBorderSoft : ColorName.borderSoft,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ColorName.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.business,
                  color: ColorName.secondary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Данные клиента',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: isDark
                      ? ColorName.darkThemeTextPrimary
                      : ColorName.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ProfileInfoRow(
            icon: Icons.business_center_outlined,
            label: 'Название компании',
            value: client.name,
            isDark: isDark,
            theme: theme,
          ),
          const SizedBox(height: 16),
          ProfileInfoRow(
            icon: Icons.email_outlined,
            label: 'Email клиента',
            value: client.email,
            isDark: isDark,
            theme: theme,
          ),
          const SizedBox(height: 16),
          ProfileInfoRow(
            icon: Icons.fingerprint,
            label: 'ID клиента',
            value: client.id,
            isDark: isDark,
            theme: theme,
          ),
        ],
      ),
    );
  }
}

