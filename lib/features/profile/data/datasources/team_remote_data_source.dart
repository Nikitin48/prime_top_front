import 'package:prime_top_front/features/profile/data/models/team_member_model.dart';

abstract class TeamRemoteDataSource {
  Future<List<TeamMemberModel>> getMembers({required String clientId});
}
