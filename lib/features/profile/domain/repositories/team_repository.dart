import 'package:prime_top_front/features/profile/domain/entities/team_member.dart';

abstract class TeamRepository {
  Future<List<TeamMember>> getMembers({required String clientId});
}
