class User {
  final String id;
  final String name;
  final String avatar;
  final String deviceId;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.avatar,
    required this.deviceId,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String,
      deviceId: json['deviceId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'deviceId': deviceId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
