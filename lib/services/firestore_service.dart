import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rumour/models/index.dart';

class FirestoreService {
  final FirebaseFirestore _db;

  FirestoreService({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  /// Creates a new room with a unique code
  Future<String> createRoom(String code) async {
    try {
      final docRef = await _db.collection('rooms').add({
        'code': code,
        'createdAt': FieldValue.serverTimestamp(),
        'memberCount': 1,
        'lastMessage': null,
      });
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create room: $e');
    }
  }

  /// Gets room ID by code, creates if doesn't exist
  Future<String> getOrCreateRoom(String code) async {
    try {
      final query = await _db.collection('rooms').where('code', isEqualTo: code).limit(1).get();

      if (query.docs.isNotEmpty) {
        return query.docs.first.id;
      }

      // Room doesn't exist, create it
      return await createRoom(code);
    } catch (e) {
      throw Exception('Failed to get or create room: $e');
    }
  }

  /// Sends a message to a room
  Future<void> sendMessage({
    required String roomId,
    required String userId,
    required String userName,
    required String userAvatar,
    required String text,
  }) async {
    try {
      await _db.collection('messages').doc(roomId).collection('messages').add({
        'userId': userId,
        'userName': userName,
        'userAvatar': userAvatar,
        'text': text,
        'timestamp': FieldValue.serverTimestamp(),
        'hidden': false,
      });

      // Update room's last message
      await _db.collection('rooms').doc(roomId).update({
        'lastMessage': text,
      });
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  /// Gets messages from a room as a stream (for real-time updates)
  Stream<List<Message>> getMessagesStream(String roomId, {int limit = 30}) {
    try {
      return _db
          .collection('messages')
          .doc(roomId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs
            .map((doc) => Message.fromJson(doc.data(), doc.id))
            .toList()
            .reversed
            .toList();
      });
    } catch (e) {
      throw Exception('Failed to get messages: $e');
    }
  }

  /// Subscribes to room changes
  Stream<Room?> subscribeToRoom(String roomId) {
    try {
      return _db.collection('rooms').doc(roomId).snapshots().map((snapshot) {
        if (!snapshot.exists) return null;
        return Room.fromJson(snapshot.data() as Map<String, dynamic>, snapshot.id);
      });
    } catch (e) {
      throw Exception('Failed to subscribe to room: $e');
    }
  }

  /// Gets a single room by ID
  Future<Room?> getRoom(String roomId) async {
    try {
      final doc = await _db.collection('rooms').doc(roomId).get();
      if (!doc.exists) return null;
      return Room.fromJson(doc.data() as Map<String, dynamic>, doc.id);
    } catch (e) {
      throw Exception('Failed to get room: $e');
    }
  }

  /// Checks if a room exists by code
  Future<bool> roomExistsByCode(String code) async {
    try {
      final query = await _db.collection('rooms').where('code', isEqualTo: code).limit(1).get();
      return query.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
