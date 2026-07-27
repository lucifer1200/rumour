import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:rumour/models/user.dart';

class LocalStorageService {
  static late SharedPreferences _prefs;

  /// Initialize SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Saves a user identity for a specific room
  static Future<void> saveUserIdentity(String roomId, User user) async {
    try {
      final key = 'user_$roomId';
      final userJson = jsonEncode(user.toJson());
      await _prefs.setString(key, userJson);
    } catch (e) {
      throw Exception('Failed to save user identity: $e');
    }
  }

  /// Retrieves a user identity for a specific room
  static Future<User?> getUserIdentity(String roomId) async {
    try {
      final key = 'user_$roomId';
      final userJson = _prefs.getString(key);
      if (userJson == null) return null;
      return User.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  /// Checks if user identity exists for a room
  static bool hasUserIdentity(String roomId) {
    final key = 'user_$roomId';
    return _prefs.containsKey(key);
  }

  /// Caches messages for a room
  static Future<void> cacheMessages(String roomId, List<String> messageIds) async {
    try {
      final key = 'messages_$roomId';
      await _prefs.setStringList(key, messageIds);
    } catch (e) {
      throw Exception('Failed to cache messages: $e');
    }
  }

  /// Gets cached message IDs for a room
  static List<String> getCachedMessageIds(String roomId) {
    final key = 'messages_$roomId';
    return _prefs.getStringList(key) ?? [];
  }

  /// Clears all user data (for logout/reset)
  static Future<void> clearAll() async {
    try {
      await _prefs.clear();
    } catch (e) {
      throw Exception('Failed to clear storage: $e');
    }
  }

  /// Clears data for a specific room
  static Future<void> clearRoom(String roomId) async {
    try {
      await _prefs.remove('user_$roomId');
      await _prefs.remove('messages_$roomId');
    } catch (e) {
      throw Exception('Failed to clear room data: $e');
    }
  }
}
