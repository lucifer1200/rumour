import 'dart:math';
import 'package:rumour/models/index.dart';

import '../services/firestore_service.dart';

class RoomRepository {
  final FirestoreService _firestoreService;

  RoomRepository({required FirestoreService firestoreService})
      : _firestoreService = firestoreService;

  /// Creates a new room with a random code
  Future<Room> createRoom() async {
    final code = _generateRoomCode();
    final roomId = await _firestoreService.createRoom(code);
    final room = await _firestoreService.getRoom(roomId);
    if (room == null) {
      throw Exception('Failed to create room');
    }
    return room;
  }

  /// Joins an existing room by code
  Future<Room> joinRoomByCode(String code) async {
    if (code.isEmpty) {
      throw Exception('Room code cannot be empty');
    }

    // Validate code format
    if (!_isValidRoomCode(code)) {
      throw Exception('Invalid room code format');
    }

    try {
      final roomId = await _firestoreService.getOrCreateRoom(code);
      final room = await _firestoreService.getRoom(roomId);
      if (room == null) {
        throw Exception('Room not found');
      }
      return room;
    } catch (e) {
      throw Exception('Failed to join room: $e');
    }
  }

  /// Gets a room by ID
  Future<Room?> getRoom(String roomId) async {
    return await _firestoreService.getRoom(roomId);
  }

  /// Subscribes to room updates
  Stream<Room?> subscribeToRoom(String roomId) {
    return _firestoreService.subscribeToRoom(roomId);
  }

  /// Generates a random 4-6 character room code
  String _generateRoomCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rng = Random();
    final length = 4 + rng.nextInt(3);
    String code = '';
    for (int i = 0; i < length; i++) {
      code += chars[rng.nextInt(chars.length)];
    }
    return code;
  }

  /// Validates room code format
  bool _isValidRoomCode(String code) {
    final regex = RegExp(r'^[A-Z0-9]{4,6}$');
    return regex.hasMatch(code.toUpperCase());
  }
}
