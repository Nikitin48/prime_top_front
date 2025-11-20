import 'package:prime_top_front/features/profile/domain/entities/team_member.dart';

class TeamMemberModel extends TeamMember {
  const TeamMemberModel({
    required super.id,
    required super.email,
    super.createdAt,
  });

  factory TeamMemberModel.fromJson(Map<String, dynamic> json) {
    return TeamMemberModel(
      id: (json['id'] ?? '').toString(),
      email: json['email'] as String? ?? '',
      createdAt: json['created_at'] as String?,
    );
  }

  TeamMember toEntity() => this;
}
