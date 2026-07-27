class Room {
  final String id;
  final String code;
  final DateTime createdAt;
  final int memberCount;
  final String? lastMessage;

  Room({
    required this.id,
    required this.code,
    required this.createdAt,
    required this.memberCount,
    this.lastMessage,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] as String,
      code: json['code'] as String,
      createdAt: (json['createdAt'] as dynamic)?.toDate() ?? DateTime.now(),
      memberCount: json['memberCount'] as int? ?? 0,
      lastMessage: json['lastMessage'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'createdAt': createdAt,
      'memberCount': memberCount,
      'lastMessage': lastMessage,
    };
  }
}
