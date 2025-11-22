import 'package:prime_top_front/features/auth/domain/entities/user.dart';

import 'client_model.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.client,
    super.firstName,
    super.lastName,
    super.createdAt,
    super.token,
    super.expiresIn,
    super.isAdmin = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    bool isAdminValue = false;
    if (json.containsKey('is_admin')) {
      final isAdminField = json['is_admin'];
      if (isAdminField is bool) {
        isAdminValue = isAdminField;
      } else if (isAdminField is String) {
        isAdminValue = isAdminField.toLowerCase() == 'true';
      }
    } else if (json.containsKey('user_is_admin')) {
      final userIsAdminField = json['user_is_admin'];
      if (userIsAdminField is bool) {
        isAdminValue = userIsAdminField;
      } else if (userIsAdminField is String) {
        isAdminValue = userIsAdminField.toLowerCase() == 'true';
      }
    }
    
    return UserModel(
      id: json['id']?.toString() ?? '',
      email: json['email'] as String? ?? '',
      client: ClientModel.fromJson(
        json['client'] as Map<String, dynamic>? ?? {},
      ),
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      createdAt: json['created_at'] as String?,
      token: json['token'] as String?,
      expiresIn: json['expires_in'] as int?,
      isAdmin: isAdminValue,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      'client': (client as ClientModel).toJson(),
      if (createdAt != null) 'created_at': createdAt,
      if (token != null) 'token': token,
      if (expiresIn != null) 'expires_in': expiresIn,
      'is_admin': isAdmin,
    };
  }
}
