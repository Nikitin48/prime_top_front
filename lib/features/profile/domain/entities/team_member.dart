import 'package:equatable/equatable.dart';

class TeamMember extends Equatable {
  const TeamMember({
    required this.id,
    required this.email,
    this.createdAt,
  });

  final String id;
  final String email;
  final String? createdAt;

  @override
  List<Object?> get props => [id, email, createdAt];
}
