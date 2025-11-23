import 'package:prime_top_front/core/utils/xss_protection.dart';
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
    
    try {
      ClientModel client;
      if (json.containsKey('client') && json['client'] != null) {
        if (json['client'] is Map<String, dynamic>) {
          client = ClientModel.fromJson(json['client'] as Map<String, dynamic>);
        } else {
          client = const ClientModel(id: '', name: '', email: '');
        }
      } else {
        client = const ClientModel(id: '', name: '', email: '');
      }
      
      return UserModel(
        id: XssProtection.sanitize(json['id']?.toString()),
        email: XssProtection.validateAndSanitizeEmail(json['email'] as String?) ?? '',
        client: client,
        firstName: XssProtection.validateAndSanitizeName(json['first_name'] as String?),
        lastName: XssProtection.validateAndSanitizeName(json['last_name'] as String?),
        createdAt: json['created_at'] as String?,
        token: json['token'] as String?,
        expiresIn: json['expires_in'] is int ? json['expires_in'] as int? : null,
        isAdmin: isAdminValue,
      );
    } catch (e) {
      return UserModel(
        id: '',
        email: '',
        client: const ClientModel(id: '', name: '', email: ''),
        isAdmin: false,
      );
    }
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
