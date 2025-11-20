import 'package:flutter/material.dart';
import 'package:prime_top_front/core/gen/colors.gen.dart';
import 'package:prime_top_front/features/auth/domain/entities/user.dart';
import 'package:prime_top_front/features/profile/presentation/widgets/profile_info_row.dart';

class UserInfoCard extends StatelessWidget {
  const UserInfoCard({
    super.key,
    required this.user,
    required this.formatDate,
  });

  final User user;
  final String Function(String?) formatDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorName.primary.withValues(alpha: 0.14),
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
                  color: ColorName.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.account_circle,
                  color: ColorName.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Аккаунт пользователя',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: isDark ? ColorName.darkThemeTextPrimary : ColorName.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ProfileInfoRow(
            icon: Icons.email_outlined,
            label: 'Email',
            value: user.email,
            isDark: isDark,
            theme: theme,
          ),
          const SizedBox(height: 16),
          ProfileInfoRow(
            icon: Icons.fingerprint,
            label: 'ID пользователя',
            value: user.id,
            isDark: isDark,
            theme: theme,
          ),
          if (user.createdAt != null && user.createdAt!.isNotEmpty) ...[
            const SizedBox(height: 16),
            ProfileInfoRow(
              icon: Icons.calendar_today_outlined,
              label: 'Дата регистрации',
              value: formatDate(user.createdAt),
              isDark: isDark,
              theme: theme,
            ),
          ],
        ],
      ),
    );
  }
}
