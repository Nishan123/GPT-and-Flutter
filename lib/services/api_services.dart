import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:gpt_flutter/constants.dart';
import 'package:gpt_flutter/models/message_model.dart';
import 'package:gpt_flutter/services/database_services.dart';

class ApiService {
  final dio = Dio();
  final uri = "https://openrouter.ai/api/v1/chat/completions";
  final DatabaseServices _databaseServices = DatabaseServices();
  Future<String> sendQuestion(String question, String historyDocId) async {
    try {
      final res = await dio.post(
        uri,
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer $gptApi",
          },
        ),
        data: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {
              "role": "user",
              "content": [
                {"type": "text", "text": question},
              ],
            },
          ],
        }),
      );
      
      String aiResponseContent = "";
      if (res.statusCode == 200) {
        final MessageModel userQuestion = MessageModel(
          messageId: DateTime.now().millisecondsSinceEpoch.toString(),
          createdAt: DateTime.now(),
          content: question,
          isUser: true,
        );
        await _databaseServices.addMessageToChatHistory(
          userQuestion,
          historyDocId,
        );

        // ai response 
        aiResponseContent = res.data['choices'][0]['message']['content'];
        final MessageModel aiResponse = MessageModel(
          messageId: DateTime.now().millisecondsSinceEpoch.toString(),
          createdAt: DateTime.now(),
          content: aiResponseContent,
          isUser: false,
        );
        await _databaseServices.addMessageToChatHistory(
          aiResponse,
          historyDocId,
        );
      }

      return aiResponseContent;
    } catch (e) {
      debugPrint("Failed to send question: $e");
      return "";
    }
  }
}
