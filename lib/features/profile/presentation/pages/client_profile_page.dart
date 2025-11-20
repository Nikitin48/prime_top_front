import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:prime_top_front/core/config/api_config.dart';
import 'package:prime_top_front/core/network/network_client.dart';
import 'package:prime_top_front/core/widgets/screen_wrapper.dart';
import 'package:prime_top_front/features/auth/application/cubit/auth_cubit.dart';
import 'package:prime_top_front/features/profile/application/cubit/team_members_cubit.dart';
import 'package:prime_top_front/features/profile/application/cubit/team_members_state.dart';
import 'package:prime_top_front/features/profile/data/datasources/team_remote_data_source_impl.dart';
import 'package:prime_top_front/features/profile/data/team_repository_impl.dart';
import 'package:prime_top_front/features/profile/domain/entities/team_member.dart';
import 'package:prime_top_front/features/profile/presentation/widgets/client_info_card.dart';
import 'package:prime_top_front/features/profile/presentation/widgets/logout_button.dart';
import 'package:prime_top_front/features/profile/presentation/widgets/profile_header.dart';
import 'package:prime_top_front/features/profile/presentation/widgets/team_members_card.dart';
import 'package:prime_top_front/features/profile/presentation/widgets/unauthorized_message.dart';
import 'package:prime_top_front/features/profile/presentation/widgets/user_info_card.dart';

class ClientProfilePage extends StatefulWidget {
  const ClientProfilePage({super.key});

  @override
  State<ClientProfilePage> createState() => _ClientProfilePageState();
}

class _ClientProfilePageState extends State<ClientProfilePage> {
  late final TeamMembersCubit _teamCubit;

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '-';
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd.MM.yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  @override
  void initState() {
    super.initState();
    final authCubit = context.read<AuthCubit>();
    final networkClient = HttpClient(baseUrl: ApiConfig.baseUrl);
    final dataSource = TeamRemoteDataSourceImpl(
      networkClient: networkClient,
      baseUrl: ApiConfig.baseUrl,
      getAuthToken: () => authCubit.state.user?.token,
    );
    final repository = TeamRepositoryImpl(dataSource);
    _teamCubit = TeamMembersCubit(repository);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = authCubit.state.user;
      if (user != null) {
        _teamCubit.load(user.client.id);
      }
    });
  }

  @override
  void dispose() {
    _teamCubit.close();
    super.dispose();
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

          return BlocProvider.value(
            value: _teamCubit,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth > 900;
                    final cardWidth = isWide ? (constraints.maxWidth - 24) / 2 : constraints.maxWidth;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const ProfileHeader(),
                        const SizedBox(height: 24),
                        Wrap(
                          spacing: 24,
                          runSpacing: 24,
                          children: [
                            SizedBox(
                              width: cardWidth,
                              child: UserInfoCard(
                                user: user,
                                formatDate: _formatDate,
                              ),
                            ),
                            SizedBox(
                              width: cardWidth,
                              child: ClientInfoCard(
                                client: user.client,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        BlocBuilder<TeamMembersCubit, TeamMembersState>(
                          builder: (context, teamState) {
                            if (teamState.isLoading) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            final members = teamState.members.isNotEmpty
                                ? teamState.members
                                : [
                                    TeamMember(
                                      id: user.id,
                                      email: user.email,
                                      createdAt: user.createdAt,
                                    ),
                                  ];
                            return TeamMembersCard(
                              members: members,
                              currentUserId: user.id,
                            );
                          },
                        ),
                        const SizedBox(height: 32),
                        const LogoutButton(),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


