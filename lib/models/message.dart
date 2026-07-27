class Message {
  final String id;
  final String roomId;
  final String userId;
  final String userName;
  final String userAvatar;
  final String text;
  final DateTime timestamp;
  final bool hidden;

  Message({
    required this.id,
    required this.roomId,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.text,
    required this.timestamp,
    this.hidden = false,
  });

  factory Message.fromJson(Map<String, dynamic> json, String messageId) {
    return Message(
      id: messageId,
      roomId: json['roomId'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userAvatar: json['userAvatar'] as String,
      text: json['text'] as String,
      timestamp: (json['timestamp'] as dynamic)?.toDate() ?? DateTime.now(),
      hidden: json['hidden'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'text': text,
      'timestamp': timestamp,
      'hidden': hidden,
    };
  }
}
