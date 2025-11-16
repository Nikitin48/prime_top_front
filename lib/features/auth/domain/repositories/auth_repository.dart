import 'package:prime_top_front/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<User> login({required String email, required String password});
  Future<User> register({
    required String email,
    required String password,
    required String companyName,
  });
  Future<void> logout();
}


