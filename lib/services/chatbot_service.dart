// Django 서버로 ID 전송
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../shared/models/chatbot.dart';



class ChatbotService {
  static const String baseUrl = "http://3.37.197.243:8000";

  static Future<List<ChatbotData>> fetchChatbotData(int userId) async {
    try {
      final url = Uri.parse("$baseUrl/LLM_QUEST/");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id": userId}),
      );

      if (response.statusCode == 200) {
        final String decodedBody = utf8.decode(response.bodyBytes);
        final List<dynamic> jsonList = jsonDecode(decodedBody);

        return jsonList.map((item) => ChatbotData.fromJson(item)).toList();
      } else {
        throw Exception(
            "Server responded with status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching stamp data: $e");
      rethrow;
    }
  }
}
