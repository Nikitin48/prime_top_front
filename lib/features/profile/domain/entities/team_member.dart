import 'package:equatable/equatable.dart';

class TeamMember extends Equatable {
  const TeamMember({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.createdAt,
  });

  final String id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? createdAt;

  @override
  List<Object?> get props => [id, email, firstName, lastName, createdAt];
}
