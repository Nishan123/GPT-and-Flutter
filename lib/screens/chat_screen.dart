import 'package:flutter/material.dart';
import 'package:gpt_flutter/models/chat_history_model.dart';
import 'package:gpt_flutter/models/message_model.dart';
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
  String? historyDocId;
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
    final docId = await DatabaseServices().createAChatHistory(newChatHistory);
    setState(() {
      historyDocId = docId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<MessageModel>>(
                stream: DatabaseServices().getAllChatHistory(historyDocId!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.data!.isEmpty) {
                    return Center(child: Text("No messages found"));
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final message = snapshot.data![index];
                      return Row(
                        mainAxisAlignment: message.isUser == true
                            ? MainAxisAlignment.end
                            : MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 220,
                            child: Text(message.content, textAlign: message.isUser == true?TextAlign.end:TextAlign.start,)),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                MessageTextField(messageController: messageController),
                SendButton(
                  onTap: historyDocId == null
                      ? () {}
                      : () {
                          // Disable if not initialized
                          ApiService().sendQuestion(
                            messageController.text,
                            historyDocId!,
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
