import 'package:prime_top_front/features/auth/domain/entities/user.dart';

import 'client_model.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.client,
    super.createdAt,
    super.token,
    super.expiresIn,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      email: json['email'] as String? ?? '',
      client: ClientModel.fromJson(
        json['client'] as Map<String, dynamic>? ?? {},
      ),
      createdAt: json['created_at'] as String?,
      token: json['token'] as String?,
      expiresIn: json['expires_in'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'client': (client as ClientModel).toJson(),
      if (createdAt != null) 'created_at': createdAt,
      if (token != null) 'token': token,
      if (expiresIn != null) 'expires_in': expiresIn,
    };
  }
}

