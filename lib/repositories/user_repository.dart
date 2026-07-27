import 'package:uuid/uuid.dart';
import 'package:rumour/models/index.dart';
import 'package:rumour/services/index.dart';
import 'dart:io';

class UserRepository {
  final RandomUserService _randomUserService;
  final LocalStorageService _localStorageService;

  UserRepository({
    required RandomUserService randomUserService,
    required LocalStorageService localStorageService,
  })  : _randomUserService = randomUserService,
        _localStorageService = localStorageService;

  /// Gets or creates a user identity for a room
  Future<User> getOrCreateUserIdentity(String roomId) async {
    // Check if user already exists locally for this room
    final existingUser = await _localStorageService.getUserIdentity(roomId);
    if (existingUser != null) {
      return existingUser;
    }

    // Create new user identity
    final randomUser = await _randomUserService.fetchRandomUser();
    final deviceId = _getDeviceId();

    final user = User(
      id: const Uuid().v4(),
      name: randomUser.fullName,
      avatar: randomUser.picture,
      deviceId: deviceId,
      createdAt: DateTime.now(),
    );

    // Save to local storage
    await _localStorageService.saveUserIdentity(roomId, user);
    return user;
  }

  /// Gets the stored user identity for a room (returns null if not found)
  Future<User?> getUserIdentity(String roomId) async {
    return await _localStorageService.getUserIdentity(roomId);
  }

  /// Clears user identity for a room
  Future<void> clearUserIdentity(String roomId) async {
    await _localStorageService.clearRoom(roomId);
  }

  /// Gets a device-specific identifier
  String _getDeviceId() {
    // For mobile, this would use device_info_plus plugin
    // For now, generate a unique ID based on time and random
    return const Uuid().v4();
  }
}
