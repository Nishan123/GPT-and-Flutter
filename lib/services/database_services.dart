import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:gpt_flutter/models/chat_history_model.dart';
import 'package:gpt_flutter/models/message_model.dart';

class DatabaseServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String uid = "123";

  // create chat history method
  Future<String> createAChatHistory(ChatHistoryModel newChatHistory) async {
    final docId = uid + DateTime.now().millisecondsSinceEpoch.toString();
    try {
      await _firestore
          .collection("chats")
          .doc(docId)
          .set(newChatHistory.toMap());
      return docId;
    } catch (e) {
      debugPrint("Failed to create chat history: $e");
      return "";
    }
  }

  // add message to chat history
  Future<void> addMessageToChatHistory(
    MessageModel newMessage,
    String historyDocId,
  ) async {
    try {
      await _firestore.collection("chats").doc(historyDocId).update({
        "messages": FieldValue.arrayUnion([newMessage.toMap()]),
      });
    } catch (e) {
      debugPrint("Failed to add new message to chat history: $e");
    }
  }

  Stream<List<MessageModel>> getAllChatHistory(String historyId) {
  try {
    return _firestore
        .collection("chats")
        .doc(historyId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data()!;
        final messagesData = data['messages'] as List<dynamic>? ?? [];
        
        return messagesData.map((messageMap) {
          return MessageModel(
            messageId: messageMap['messageId'] as String,
            createdAt: DateTime.fromMillisecondsSinceEpoch(
              messageMap['createdAt'] as int,
            ),
            content: messageMap['content'] as String,
            isUser: messageMap['isUser'] as bool,
          );
        }).toList();
      }
      return <MessageModel>[];
    });
  } catch (e) {
    debugPrint("Failed to get chat history: $e");
    return Stream.value(<MessageModel>[]);
  }
}
}
