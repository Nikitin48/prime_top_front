import 'package:prime_top_front/features/auth/domain/entities/client.dart';

class ClientModel extends Client {
  const ClientModel({
    required super.id,
    required super.name,
    required super.email,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}

