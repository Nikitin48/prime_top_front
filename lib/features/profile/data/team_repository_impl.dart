import 'package:prime_top_front/features/profile/data/datasources/team_remote_data_source.dart';
import 'package:prime_top_front/features/profile/domain/entities/team_member.dart';
import 'package:prime_top_front/features/profile/domain/repositories/team_repository.dart';

class TeamRepositoryImpl implements TeamRepository {
  TeamRepositoryImpl(this._remoteDataSource);

  final TeamRemoteDataSource _remoteDataSource;

  @override
  Future<List<TeamMember>> getMembers({required String clientId}) async {
    final models = await _remoteDataSource.getMembers(clientId: clientId);
    return models.map((m) => m.toEntity()).toList();
  }
}
