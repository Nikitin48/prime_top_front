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
        gradient: LinearGradient(
          colors: [
            ColorName.secondary.withValues(alpha: 0.12),
            isDark ? ColorName.darkThemeCardBackground : Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? ColorName.darkThemeBorderSoft : ColorName.borderSoft),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: ColorName.secondary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.business,
                  color: ColorName.secondary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Данные организации',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: isDark ? ColorName.darkThemeTextPrimary : ColorName.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ProfileInfoRow(
            icon: Icons.business_center_outlined,
            label: 'Название',
            value: client.name,
            isDark: isDark,
            theme: theme,
          ),
          const SizedBox(height: 16),
          ProfileInfoRow(
            icon: Icons.email_outlined,
            label: 'Email',
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
