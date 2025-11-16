import 'dart:async';

import 'package:prime_top_front/features/auth/domain/entities/user.dart';
import 'package:prime_top_front/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  User? _currentUser;

  @override
  Future<User> login({required String email, required String password}) async {
    // Stub: emulate network delay and "success"
    await Future<void>.delayed(const Duration(milliseconds: 500));
    _currentUser = User(id: 'stub-id', email: email, companyName: 'Stub Company');
    return _currentUser!;
  }

  @override
  Future<User> register({
    required String email,
    required String password,
    required String companyName,
  }) async {
    // Stub: emulate network delay and "success"
    await Future<void>.delayed(const Duration(milliseconds: 700));
    _currentUser = User(id: 'stub-id', email: email, companyName: companyName);
    return _currentUser!;
  }

  @override
  Future<void> logout() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _currentUser = null;
  }
}


