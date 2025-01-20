import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'secure_storage_service.dart';

class GroqAIService {
  static const String endpoint =
      'https://api.groq.com/openai/v1/chat/completions';

  // Function to call the GROQ AI API
  static Future<String?> summarizeLogs(String compiledLogs) async {
    try {
      final apiKey = await SecureStorageService.getApiKey();
      if (apiKey == null) {
        throw Exception('API key is not set.');
      }

      final url = Uri.parse(endpoint);
      final body = {
        "model": "llama-3.3-70b-versatile",
        "messages": [
          {
            "role": "system",
            "content":
                "You are a summarization assistant. Summarize the provided logs."
          },
          {
            "role": "user",
            "content": compiledLogs,
          }
        ],
        "max_tokens": 4096,
      };

      // Log before making the request
      debugPrint('Connecting to API at: $endpoint');
      debugPrint(
          'Sending request with the following body: ${jsonEncode(body)}');

      // Make the request
      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $apiKey',
            },
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));

      // Log response status and body
      debugPrint('API Response Status Code: ${response.statusCode}');
      debugPrint('API Response Body: ${response.body}');

      if (compiledLogs.trim().isEmpty) {
        debugPrint('Error: Logs are empty or null.');
        return null;
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final summary = data['choices'][0]['message']['content'];
        // Log successful response processing
        debugPrint('Successfully received summary from API.');
        return summary;
      } else {
        // Log failure with the response body
        debugPrint(
            'Failed to summarize logs. Error response: ${response.body}');
        throw Exception('Failed to summarize logs: ${response.body}');
      }
    } catch (e) {
      // Log errors encountered during the process
      debugPrint('Error occurred while summarizing logs: $e');
      return null;
    }
  }

  // Wrapper function to allow calling other API methods without changing UI logic
  static Future<String?> getChatCompletion(String userMessage) async {
    try {
      final apiKey = await SecureStorageService.getApiKey();
      if (apiKey == null) {
        throw Exception('API key is not set.');
      }

      final url = Uri.parse(endpoint);
      final body = {
        "model": "llama-3.3-70b-versatile",
        "messages": [
          {
            "role": "system",
            "content":
                "You are a helpful assistant. You reply with very short answers."
          },
          {
            "role": "user",
            "content": userMessage,
          }
        ],
        "max_tokens": 100,
        "temperature": 1.2,
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        throw Exception('Failed to get response: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
