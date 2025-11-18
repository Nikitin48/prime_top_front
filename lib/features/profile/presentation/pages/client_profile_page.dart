import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:prime_top_front/core/widgets/screen_wrapper.dart';
import 'package:prime_top_front/features/auth/application/cubit/auth_cubit.dart';
import 'package:prime_top_front/features/profile/presentation/widgets/client_info_card.dart';
import 'package:prime_top_front/features/profile/presentation/widgets/logout_button.dart';
import 'package:prime_top_front/features/profile/presentation/widgets/profile_header.dart';
import 'package:prime_top_front/features/profile/presentation/widgets/unauthorized_message.dart';
import 'package:prime_top_front/features/profile/presentation/widgets/user_info_card.dart';

class ClientProfilePage extends StatelessWidget {
  const ClientProfilePage({super.key});

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '—';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd.MM.yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          if (authState.user == null) {
            return const UnauthorizedMessage();
          }

          final user = authState.user!;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const ProfileHeader(),
                  const SizedBox(height: 32),
                  UserInfoCard(
                    user: user,
                    formatDate: _formatDate,
                  ),
                  const SizedBox(height: 24),
                  ClientInfoCard(
                    client: user.client,
                  ),
                  const SizedBox(height: 32),
                  const LogoutButton(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


