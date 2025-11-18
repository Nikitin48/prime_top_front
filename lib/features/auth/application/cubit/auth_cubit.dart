import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_top_front/core/storage/auth_storage_service.dart';
import 'package:prime_top_front/features/auth/data/models/user_model.dart';
import 'package:prime_top_front/features/auth/domain/entities/user.dart';
import 'package:prime_top_front/features/auth/domain/repositories/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(
    this._repository,
    this._storageService,
  ) : super(const AuthState.unauthenticated()) {
    _loadSavedUser();
  }

  final AuthRepository _repository;
  final AuthStorageService _storageService;

  /// Загружает сохраненного пользователя при инициализации
  Future<void> _loadSavedUser() async {
    try {
      final savedUser = await _storageService.loadUser();
      if (savedUser != null && savedUser.token != null) {
        // Восстанавливаем токен в API клиенте
        _repository.restoreToken(savedUser.token);
        emit(AuthState.authenticated(savedUser));
      }
    } catch (e) {
      // Игнорируем ошибки при загрузке сохраненного пользователя
      // Оставляем состояние unauthenticated
    }
  }

  Future<void> login({required String email, required String password}) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    try {
      final user = await _repository.login(email: email, password: password);
      // Сохраняем пользователя после успешного входа
      if (user is UserModel) {
        await _storageService.saveUser(user);
      }
      emit(AuthState.authenticated(user));
    } on Exception catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.failure, errorMessage: 'Ошибка входа'));
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String clientName,
    required String clientEmail,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    try {
      final user = await _repository.register(
        email: email,
        password: password,
        clientName: clientName,
        clientEmail: clientEmail,
      );
      // Сохраняем пользователя после успешной регистрации
      if (user is UserModel) {
        await _storageService.saveUser(user);
      }
      emit(AuthState.authenticated(user));
    } on Exception catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      ));
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.failure, errorMessage: 'Ошибка регистрации'));
      emit(state.copyWith(status: AuthStatus.unauthenticated));
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    // Очищаем сохраненные данные при выходе
    await _storageService.clearUser();
    emit(const AuthState.unauthenticated());
  }
}


