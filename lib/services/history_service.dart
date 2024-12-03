import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ict_hackthon_no_attitude/shared/models/history.dart';


class HistoryService {
  static const String baseUrl = "http://3.37.197.243:8000";

  static Future<List<HistoryData>> fetchHistoryData(int userId) async {
    try {
      final url = Uri.parse("$baseUrl/history_view/");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id": userId}),
      );

      if (response.statusCode == 200) {
        final String decodedBody = utf8.decode(response.bodyBytes);
        final List<dynamic> jsonList = jsonDecode(decodedBody);

        return jsonList.map((item) => HistoryData.fromJson(item)).toList();
      } else {
        throw Exception("Server responded with status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching stamp data: $e");
      rethrow;
    }
  }
}