import 'package:prime_top_front/core/network/exceptions.dart';
import 'package:prime_top_front/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:prime_top_front/features/auth/domain/entities/user.dart';
import 'package:prime_top_front/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<User> login({required String email, required String password}) async {
    try {
      final user = await _remoteDataSource.login(email: email, password: password);
      return user;
    } on UnauthorizedException {
      rethrow;
    } on NetworkException catch (e) {
      throw Exception('Ошибка сети: ${e.message}');
    } catch (e) {
      throw Exception('Неожиданная ошибка при входе: $e');
    }
  }

  @override
  Future<User> register({
    required String email,
    required String password,
    required String clientName,
    required String clientEmail,
    String? firstName,
    String? lastName,
  }) async {
    try {
      final user = await _remoteDataSource.register(
        email: email,
        password: password,
        clientName: clientName,
        clientEmail: clientEmail,
        firstName: firstName,
        lastName: lastName,
      );
      return user;
    } on ConflictException {
      rethrow;
    } on ClientException catch (e) {
      throw Exception('Ошибка регистрации: ${e.message}');
    } on NetworkException catch (e) {
      throw Exception('Ошибка сети: ${e.message}');
    } catch (e) {
      throw Exception('Неожиданная ошибка при регистрации: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _remoteDataSource.logout();
    } catch (e) {
      // При выходе игнорируем ошибки
    }
  }

  @override
  void restoreToken(String? token) {
    _remoteDataSource.restoreToken(token);
  }
}
