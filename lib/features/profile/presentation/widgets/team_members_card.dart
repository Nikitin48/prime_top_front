import 'package:flutter/material.dart';
import 'package:prime_top_front/core/gen/colors.gen.dart';
import 'package:prime_top_front/features/profile/domain/entities/team_member.dart';

class TeamMembersCard extends StatelessWidget {
  const TeamMembersCard({
    super.key,
    required this.members,
    required this.currentUserId,
  });

  final List<TeamMember> members;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ColorName.primary.withValues(alpha: 0.08),
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
            blurRadius: 24,
            offset: const Offset(0, 10),
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
                  Icons.group_outlined,
                  color: ColorName.primary,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Команда вашей организации',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: isDark ? ColorName.darkThemeTextPrimary : ColorName.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (members.isEmpty)
            Text(
              'Пока только вы. Добавьте коллег, чтобы работать вместе.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? ColorName.darkThemeTextSecondary : ColorName.textSecondary,
              ),
            )
          else
            Column(
              children: members.map((member) {
                final isCurrent = member.id == currentUserId;
                final name = [member.firstName, member.lastName]
                    .where((e) => e != null && e!.isNotEmpty)
                    .map((e) => e!)
                    .join(' ');
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? ColorName.primary.withOpacity(0.15)
                        : (isDark ? ColorName.darkThemeCardBackground : Colors.white),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isCurrent
                          ? ColorName.primary
                          : (isDark ? ColorName.darkThemeBorderSoft : ColorName.borderSoft),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 18,
                        color: isCurrent ? ColorName.primary : ColorName.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              member.email,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: isCurrent
                                    ? ColorName.primary
                                    : (isDark ? ColorName.darkThemeTextPrimary : ColorName.textPrimary),
                                fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                              ),
                            ),
                            if (name.isNotEmpty)
                              Text(
                                name,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: isCurrent
                                      ? ColorName.primary
                                      : (isDark ? ColorName.darkThemeTextSecondary : ColorName.textSecondary),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
