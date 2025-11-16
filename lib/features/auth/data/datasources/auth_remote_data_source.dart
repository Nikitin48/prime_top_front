import 'package:prime_top_front/features/auth/data/models/user_model.dart';

/// Интерфейс для удаленного источника данных авторизации
abstract class AuthRemoteDataSource {
  /// Регистрация нового пользователя
  Future<UserModel> register({
    required String email,
    required String password,
    required String clientName,
    required String clientEmail,
  });

  /// Вход пользователя
  Future<UserModel> login({
    required String email,
    required String password,
  });

  /// Выход пользователя
  Future<void> logout();
}

