import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAiClient {
  final String apiKey;
  final http.Client _http;

  OpenAiClient({required this.apiKey, http.Client? httpClient})
      : _http = httpClient ?? http.Client();

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $apiKey',
  };

  /// Use the Responses API (modern assistant-style). Returns raw decoded JSON.
  Future<Map<String, dynamic>> sendResponsesGeneration({
    required String model,
    required String prompt,
    int? maxTokens,
  }) async {
    final uri = Uri.parse('https://api.openai.com/v1/responses');
    final body = jsonEncode({
      'model': model,
      'input': prompt,
      if (maxTokens != null) 'max_output_tokens': maxTokens,
    });

    final res = await _http.post(uri, headers: _headers, body: body).timeout(
      const Duration(seconds: 30),
    );

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    } else {
      throw Exception('OpenAI error ${res.statusCode}: ${res.body}');
    }
  }
}
