import 'package:flutter/material.dart';

class MessageTextField extends StatelessWidget {
  final TextEditingController messageController;
  const MessageTextField({super.key, required this.messageController});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: TextField(
          controller: messageController,
          decoration: InputDecoration(
            hintText: "Send a message",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
          ),
        ),
      ),
    );
  }
}
