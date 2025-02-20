class ChatModel {
  final String id;
  final String message;
  final bool isMe;
  final DateTime timestamp;

  ChatModel({
    required this.id,
    required this.message,
    required this.isMe,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'message': message,
      'isMe': isMe,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      id: map['id'],
      message: map['message'],
      isMe: map['isMe'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}