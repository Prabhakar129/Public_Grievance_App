import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RasaChatService {
  final String rasaUrl = "http://localhost:5005/webhooks/rest/webhook";
  final storage = FlutterSecureStorage();

  Future<List<Map<String, dynamic>>> sendMessage(String message) async {
    String? token = await storage.read(key: 'auth_token');
    final response = await http.post(
      Uri.parse(rasaUrl),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "sender": "user",
        "message": message,
        "metadata": {
          "auth_token": token,
        }
      }),
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);

      if (data.isEmpty) {
        return [
          {"text": "No response from bot", "buttons": [], "dropdown": null}
        ];
      }

      List<Map<String, dynamic>> botResponses = [];
      for (var item in data) {
        botResponses.add({
          "text": item['text'] ?? "",
          "buttons": item['buttons'] ?? [],
          "dropdown": item.containsKey('custom') ? item['custom'] : null,
        });
      }

      return botResponses;
    } else {
      throw Exception("Failed to connect to Rasa server");
    }
  }
}
