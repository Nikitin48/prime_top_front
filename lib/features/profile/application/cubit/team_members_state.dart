import 'package:equatable/equatable.dart';
import 'package:prime_top_front/features/profile/domain/entities/team_member.dart';

class TeamMembersState extends Equatable {
  const TeamMembersState({
    this.members = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  final List<TeamMember> members;
  final bool isLoading;
  final String? errorMessage;

  TeamMembersState copyWith({
    List<TeamMember>? members,
    bool? isLoading,
    String? errorMessage,
  }) {
    return TeamMembersState(
      members: members ?? this.members,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [members, isLoading, errorMessage];
}
