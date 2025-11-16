import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_top_front/features/auth/domain/entities/user.dart';
import 'package:prime_top_front/features/auth/domain/repositories/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repository) : super(const AuthState.unauthenticated());

  final AuthRepository _repository;

  Future<void> login({required String email, required String password}) async {
    emit(state.copyWith(status: AuthStatus.loading, errorMessage: null));
    try {
      final user = await _repository.login(email: email, password: password);
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
    emit(const AuthState.unauthenticated());
  }
}


