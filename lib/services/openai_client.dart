import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dunno/models/ai_gift_suggestion.dart';

class AiTextGenerationRepository {
  final String apiKey;

  AiTextGenerationRepository(this.apiKey);

  Future<List<AiGiftSuggestion>> generateGiftSuggestions({
    required Map<String, dynamic> profile,
    required Map<String, dynamic> filters,
  }) async {
    final prompt = '''
Generate 3 personalized gift ideas based on the following profile and filters.
Return valid JSON ONLY in this format:

[
  {
    "title": "Gift Title",
    "description": "Gift description",
    "reason": "Why this gift fits the person",
    "estimatedPrice": 250,
    "imageUrl": "Optional image URL",
    "purchaseLink": "Optional purchase link",
    "tags": ["tag1", "tag2"],
    "category": "Category name"
  }
]

Profile: $profile
Filters: $filters
''';

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        "model": "gpt-4o-mini",
        "messages": [
          {"role": "user", "content": prompt}
        ],
        "temperature": 0.8,
        "max_tokens": 500,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('AI API error: ${response.statusCode} - ${response.body}');
    }

    final data = jsonDecode(response.body);
    final content = data["choices"]?[0]?["message"]?["content"];
    if (content == null) throw Exception('No content returned from AI');

    try {
      final parsed = jsonDecode(content);
      if (parsed is List) {
        return parsed.map((e) => AiGiftSuggestion.fromJson(e)).toList();
      } else {
        throw Exception('AI returned invalid format');
      }
    } catch (e) {
      print('❌ JSON parse error: $e');
      print('Raw AI response: $content');
      return [];
    }
  }
}
