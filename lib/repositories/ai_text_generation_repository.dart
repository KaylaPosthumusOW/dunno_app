import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dunno/models/ai_gift_suggestion.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AiTextGenerationRepository {
  final http.Client _httpClient;
  
  AiTextGenerationRepository({http.Client? httpClient}) 
      : _httpClient = httpClient ?? http.Client();

  String get _apiKey {
    final key = dotenv.env['OPENAI_API_KEY'];
    if (key == null || key.isEmpty) {
      throw Exception('OpenAI API key not found in environment variables. Please make sure you have a .env file with OPENAI_API_KEY set.');
    }
    return key;
  }

  Future<List<AiGiftSuggestion>> generateGiftSuggestions({
    required Map<String, dynamic> profile,
    required Map<String, dynamic> filters,
  }) async {
    try {
      final prompt = _buildPrompt(profile, filters);
      
      final response = await _httpClient.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          "model": "gpt-4o-mini",
          "messages": [
            {
              "role": "system", 
              "content": "You are a professional gift suggestion assistant. Always respond with valid JSON in the exact format requested."
            },
            {
              "role": "user", 
              "content": prompt
            }
          ],
          "temperature": 0.8,
          "max_tokens": 1500,
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        throw Exception('OpenAI API error: ${response.statusCode} - ${response.body}');
      }

      final data = jsonDecode(response.body);
      final content = data["choices"]?[0]?["message"]?["content"];
      
      if (content == null) {
        throw Exception('No content returned from OpenAI API');
      }

      return _parseAiResponse(content);
    } catch (e) {
      throw Exception('Failed to generate gift suggestions: $e');
    }
  }

  String _buildPrompt(Map<String, dynamic> profile, Map<String, dynamic> filters) {
    final profileInfo = '''
      Profile Information:
      - Occasion: ${profile['occasion'] ?? 'Not specified'}
      - Gender: ${profile['gender'] ?? 'Not specified'}
      - Interests/Likes: ${profile['likes'] ?? 'Not specified'}
      - Extra Notes: ${profile['extraNotes'] ?? 'None'}
      ''';

    final filterInfo = '''
      Filter Preferences:
      - Relationship: ${filters['relation'] ?? 'Not specified'}
      - Budget: \$${filters['budget'] ?? '200'}
      - Gift Type: ${filters['giftType'] ?? 'Any'}
      - Gift Category: ${filters['giftCategory'] ?? 'Any'}
      - Gift Value: ${filters['giftValue'] ?? 'Any'}
      ''';

    return '''
      You are a South African gift recommendation assistant.
      Based on the following profile and filter information, generate **exactly 3 personalised gift suggestions** that are locally relevant and available in South Africa.
      Respond in ZAR currency, and US english.

      
      $profileInfo
      
      $filterInfo
      
      Please respond with ONLY a valid JSON array of exactly 3 items, each following this structure:

      [
        {
          "title": "Gift Name",
          "description": "Detailed description of the gift (15–20 words)",
          "reason": "Why this gift is perfect for this person (15–20 words)",
          "estimatedPrice": 0.00,
          "imageUrl": "https://link-to-gift-image.com/image.jpg",
          "tags": ["tag1", "tag2", "tag3"],
          "category": "category_name"
        }
      ]
      
      Do not include any text or comments outside the JSON array.

      
      Requirements:
      - Provide exactly 3 unique suggestions
      - Each suggestion should be thoughtful and personalised based on the profile
      - Price should be within or close to the specified budget
      - Tags should be relevant keywords (2-5 per suggestion)
      - Categories should be descriptive and relevant
      - Be creative but practical
      ''';
        }

  List<AiGiftSuggestion> _parseAiResponse(String content) {
    try {
      final cleanContent = content.trim();
      final jsonStart = cleanContent.indexOf('[');
      final jsonEnd = cleanContent.lastIndexOf(']') + 1;
      
      String jsonString;
      if (jsonStart >= 0 && jsonEnd > jsonStart) {
        jsonString = cleanContent.substring(jsonStart, jsonEnd);
      } else {
        jsonString = cleanContent;
      }

      final parsed = jsonDecode(jsonString);
      
      if (parsed is List) {
        final suggestions = parsed
            .map((suggestion) => AiGiftSuggestion.fromJson(suggestion as Map<String, dynamic>))
            .toList();
        
        if (suggestions.length != 3) {
          throw Exception('Expected exactly 3 suggestions, got ${suggestions.length}');
        }
        
        return suggestions;
      } else {
        throw Exception('Expected JSON array, got ${parsed.runtimeType}');
      }
    } catch (e) {
      throw Exception('Failed to parse AI response: $e. Raw content: $content');
    }
  }

  void dispose() {
    _httpClient.close();
  }
}