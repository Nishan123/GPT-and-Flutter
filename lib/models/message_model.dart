class MessageModel {
  final String messageId;
  final DateTime createdAt;
  final String content;
  final bool isUser;

  MessageModel({
    required this.messageId,
    required this.createdAt,
    required this.content,
    required this.isUser,
  });

  MessageModel copyWith({
    String? messageId,
    DateTime? createdAt,
    String? content,
    bool? isUser,
  }) {
    return MessageModel(
      messageId: messageId ?? this.messageId,
      createdAt: createdAt ?? this.createdAt,
      content: content ?? this.content,
      isUser: isUser ?? this.isUser,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'content': content,
      'isUser': isUser,
    };
  }
}
