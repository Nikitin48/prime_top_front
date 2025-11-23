import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:prime_top_front/core/config/api_config.dart';
import 'package:prime_top_front/core/gen/colors.gen.dart';
import 'package:prime_top_front/core/network/network_client.dart';
import 'package:prime_top_front/core/widgets/screen_wrapper.dart';
import 'package:prime_top_front/features/data_lake/application/cubit/data_lake_cubit.dart';
import 'package:prime_top_front/features/data_lake/data/data_lake_repository_impl.dart';
import 'package:prime_top_front/features/data_lake/data/datasources/data_lake_remote_data_source_impl.dart';
import 'package:prime_top_front/features/data_lake/presentation/pages/data_lake_page.dart';
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
  late final DataLakeCubit _dataLakeCubit;
  bool _showDataLake = false;

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
    
    // Инициализация TeamMembersCubit
    final teamDataSource = TeamRemoteDataSourceImpl(
      networkClient: networkClient,
      baseUrl: ApiConfig.baseUrl,
      getAuthToken: () => authCubit.state.user?.token,
    );
    final teamRepository = TeamRepositoryImpl(teamDataSource);
    _teamCubit = TeamMembersCubit(teamRepository);

    // Инициализация DataLakeCubit
    final dataLakeDataSource = DataLakeRemoteDataSourceImpl(
      networkClient: networkClient,
      baseUrl: ApiConfig.baseUrl,
      getAuthToken: () => authCubit.state.user?.token,
    );
    final dataLakeRepository = DataLakeRepositoryImpl(dataLakeDataSource);
    _dataLakeCubit = DataLakeCubit(dataLakeRepository);

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
    _dataLakeCubit.close();
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
          final isAdmin = user.isAdmin;

          return MultiBlocProvider(
            providers: [
              BlocProvider.value(value: _teamCubit),
              BlocProvider.value(value: _dataLakeCubit),
            ],
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: const ProfileHeader(),
                            ),
                            if (isAdmin) ...[
                              const SizedBox(width: 16),
                              ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    _showDataLake = !_showDataLake;
                                  });
                                },
                                icon: Icon(_showDataLake ? Icons.person : Icons.storage),
                                label: Text(_showDataLake ? 'Профиль' : 'Data Lake'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).brightness == Brightness.dark
                                      ? ColorName.darkThemePrimary
                                      : ColorName.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 24),
                        _showDataLake && isAdmin
                            ? const DataLakePage()
                            : _buildProfileTab(user),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileTab(user) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              isWide
                  ? IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: UserInfoCard(
                              user: user,
                              formatDate: _formatDate,
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: ClientInfoCard(
                              client: user.client,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      children: [
                        UserInfoCard(
                          user: user,
                          formatDate: _formatDate,
                        ),
                        const SizedBox(height: 24),
                        ClientInfoCard(
                          client: user.client,
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
          ),
        );
      },
    );
  }
}
