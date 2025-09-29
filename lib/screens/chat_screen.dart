import 'package:flutter/material.dart';
import 'package:gpt_flutter/models/chat_history_model.dart';
import 'package:gpt_flutter/services/api_services.dart';
import 'package:gpt_flutter/services/database_services.dart';
import 'package:gpt_flutter/widgets/message_text_field.dart';
import 'package:gpt_flutter/widgets/send_button.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();
  late String historyDocId;
  @override
  void initState() {
    super.initState();
    initilizeChatHistory();

  }

  Future<void> initilizeChatHistory() async {
    final newChatHistory = ChatHistoryModel(
      historyId: "h1",
      ownerId: "123",
      messages: [],
    );
    historyDocId = await DatabaseServices().createAChatHistory(newChatHistory);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Center(child: Text("Chat Screen")),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                MessageTextField(messageController: messageController),
                SendButton(
                  onTap: () {
                    ApiService().sendQuestion(
                      messageController.text,
                      historyDocId,
                    );
                    messageController.clear();
                  },
                ),
                SizedBox(width: 12),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
