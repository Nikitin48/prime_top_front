import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:prime_top_front/features/auth/data/models/user_model.dart';

class AuthStorageService {
  static const String _userKey = 'auth_user';
  static const String _tokenKey = 'auth_token';

  Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson());
    await prefs.setString(_userKey, userJson);
    if (user.token != null) {
      await prefs.setString(_tokenKey, user.token!);
    }
  }

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
      await clearUser();
      return null;
    }
  }

  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_tokenKey);
  }

  Future<bool> hasStoredUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_userKey);
  }
}
