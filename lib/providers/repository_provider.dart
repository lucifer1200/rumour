import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rumour/repositories/index.dart';
import 'package:rumour/providers/services_provider.dart';

// User Repository
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final randomUserService = ref.watch(randomUserServiceProvider);
  final localStorageService = ref.watch(localStorageServiceProvider);

  return UserRepository(
    randomUserService: randomUserService,
    localStorageService: localStorageService,
  );
});

// Room Repository
final roomRepositoryProvider = Provider<RoomRepository>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);

  return RoomRepository(
    firestoreService: firestoreService,
  );
});

// Message Repository
final messageRepositoryProvider = Provider<MessageRepository>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);

  return MessageRepository(
    firestoreService: firestoreService,
  );
});
