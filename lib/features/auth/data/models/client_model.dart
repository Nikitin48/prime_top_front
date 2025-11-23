import 'package:prime_top_front/core/utils/xss_protection.dart';
import 'package:prime_top_front/features/auth/domain/entities/client.dart';

class ClientModel extends Client {
  const ClientModel({
    required super.id,
    required super.name,
    required super.email,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    try {
      return ClientModel(
        id: XssProtection.sanitize(json['id']?.toString()),
        name: XssProtection.sanitize(json['name'] as String?),
        email: XssProtection.validateAndSanitizeEmail(json['email'] as String?) ?? '',
      );
    } catch (e) {
      return const ClientModel(id: '', name: '', email: '');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}
