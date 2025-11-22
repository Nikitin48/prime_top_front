import 'package:prime_top_front/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> register({
    required String email,
    required String password,
    required String clientName,
    required String clientEmail,
    String? firstName,
    String? lastName,
  });

  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<void> logout();

  void restoreToken(String? token);
}
