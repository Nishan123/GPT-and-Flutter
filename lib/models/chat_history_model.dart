import 'package:gpt_flutter/models/message_model.dart';

class ChatHistoryModel {
  final String historyId;
  final String ownerId;
  final List<MessageModel> messages;

  ChatHistoryModel({
    required this.historyId,
    required this.ownerId,
    required this.messages,
  });

  Map<String, dynamic> toMap() {
    return {
      'historyId': historyId,
      'ownerId': ownerId,
      'messages': messages.map((message) => message.toMap()).toList(),
    };
  }
  ChatHistoryModel copyWith({
    String? historyId,
    String? ownerId,
    List<MessageModel>? messages,
  }) {
    return ChatHistoryModel(
      historyId: historyId ?? this.historyId,
      ownerId: ownerId ?? this.ownerId,
      messages: messages ?? this.messages,
    );
  }
}
