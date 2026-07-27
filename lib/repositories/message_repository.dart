import 'package:rumour/models/index.dart';
import 'package:rumour/services/firestore_service.dart';

class MessageRepository {
  final FirestoreService _firestoreService;

  MessageRepository({required FirestoreService firestoreService})
      : _firestoreService = firestoreService;

  /// Sends a message to a room
  Future<void> sendMessage({
    required String roomId,
    required String userId,
    required String userName,
    required String userAvatar,
    required String text,
  }) async {
    if (text.trim().isEmpty) {
      throw Exception('Message cannot be empty');
    }

    await _firestoreService.sendMessage(
      roomId: roomId,
      userId: userId,
      userName: userName,
      userAvatar: userAvatar,
      text: text.trim(),
    );
  }

  /// Gets messages from a room as a stream
  Stream<List<Message>> getMessagesStream(String roomId, {int limit = 30}) {
    return _firestoreService.getMessagesStream(roomId, limit: limit);
  }
}
