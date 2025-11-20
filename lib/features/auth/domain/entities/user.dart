import 'package:equatable/equatable.dart';

import 'client.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.email,
    required this.client,
    this.firstName,
    this.lastName,
    this.createdAt,
    this.token,
    this.expiresIn,
  });

  final String id;
  final String email;
  final Client client;
  final String? firstName;
  final String? lastName;
  final String? createdAt;
  final String? token;
  final int? expiresIn;

  @override
  List<Object?> get props => [id, email, client, firstName, lastName, createdAt, token, expiresIn];
}


