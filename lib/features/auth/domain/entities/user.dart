import 'package:equatable/equatable.dart';

import 'client.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.email,
    required this.client,
    this.createdAt,
    this.token,
    this.expiresIn,
  });

  final String id;
  final String email;
  final Client client;
  final String? createdAt;
  final String? token;
  final int? expiresIn;

  @override
  List<Object?> get props => [id, email, client, createdAt, token, expiresIn];
}


