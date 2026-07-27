import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rumour/models/index.dart';

// Current room
final currentRoomProvider = StateProvider<Room?>((ref) => null);

// Current user
final currentUserProvider = StateProvider<User?>((ref) => null);

// Loading state
final isLoadingProvider = StateProvider<bool>((ref) => false);

// Error messages
final errorProvider = StateProvider<String?>((ref) => null);

// Theme mode (dark/light)
final themeModeProvider = StateProvider<bool>((ref) => true); // true = dark, false = light
