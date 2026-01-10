import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ChatService {
  final String _baseUrl = "https://api.openai.com/v1/responses";
  final String? _apiKey = dotenv.env['OPENAI_API_KEY'];

  Future<String> sendMessage(String message) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_apiKey',
      },
      body: jsonEncode({
        "model": "gpt-5-nano",
        "input": message,
        "store": true
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Adjust this depending on the response structure
      return data['output']?[0]?['content']?[0]?['text'] ?? "No response";
    } else {
      return "Error: ${response.statusCode}";
    }
  }
}
