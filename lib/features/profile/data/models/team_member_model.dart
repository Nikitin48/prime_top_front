import 'package:prime_top_front/features/profile/domain/entities/team_member.dart';

class TeamMemberModel extends TeamMember {
  const TeamMemberModel({
    required super.id,
    required super.email,
    super.firstName,
    super.lastName,
    super.createdAt,
  });

  factory TeamMemberModel.fromJson(Map<String, dynamic> json) {
    return TeamMemberModel(
      id: (json['id'] ?? '').toString(),
      email: json['email'] as String? ?? '',
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      createdAt: json['created_at'] as String?,
    );
  }

  TeamMember toEntity() => this;
}
