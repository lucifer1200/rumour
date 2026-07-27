import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rumour/models/message.dart';
import 'package:rumour/providers/repository_provider.dart';

// Messages stream for a specific room
final messagesProvider = StreamProvider.family<List<Message>, String>((ref, roomId) {
  final messageRepository = ref.watch(messageRepositoryProvider);
  return messageRepository.getMessagesStream(roomId);
});
