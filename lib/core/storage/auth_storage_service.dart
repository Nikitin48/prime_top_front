import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prime_top_front/features/auth/data/models/user_model.dart';

/// Сервис для сохранения и загрузки данных аутентификации
class AuthStorageService {
  static const String _userKey = 'auth_user';
  static const String _tokenKey = 'auth_token';

  /// Сохраняет данные пользователя
  Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson());
    await prefs.setString(_userKey, userJson);
    if (user.token != null) {
      await prefs.setString(_tokenKey, user.token!);
    }
  }

  /// Загружает сохраненного пользователя
  Future<UserModel?> loadUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      if (userJson == null) {
        return null;
      }
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    } catch (e) {
      // В случае ошибки парсинга очищаем сохраненные данные
      await clearUser();
      return null;
    }
  }

  /// Очищает сохраненные данные пользователя
  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_tokenKey);
  }

  /// Проверяет, есть ли сохраненный пользователь
  Future<bool> hasStoredUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_userKey);
  }
}

