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
      print('Generated prompt length: ${prompt.length}');
      
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
        print('OpenAI API Error - Status: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('OpenAI API error: ${response.statusCode} - ${response.body}');
      }

      final data = jsonDecode(response.body);
      print('OpenAI API Response structure: ${data.keys}');
      
      final content = data["choices"]?[0]?["message"]?["content"];
      
      if (content == null) {
        print('OpenAI API Response: $data');
        throw Exception('No content returned from OpenAI API. Response structure: ${data.keys}');
      }

      print('AI Content received (length: ${content.length})');
      return _parseAiResponse(content);
    } catch (e) {
      print('Generate gift suggestions error: $e');
      if (e.toString().contains('Failed to generate gift suggestions:')) {
        rethrow;
      }
      throw Exception('Failed to generate gift suggestions: $e');
    }
  }

  String _buildPrompt(Map<String, dynamic> profile, Map<String, dynamic> filters) {
    final occasion = profile['eventType'] ?? 'Not specified';
    final gender = _formatGender(profile['gender']);
    final age = profile['age'] != null ? 'Age ${profile['age']}' : 'Age not specified';
    final likes = _formatLikes(profile['likes']);
    final extraNotes = profile['extraNotes'] ?? 'None';

    final relationship = filters['title'] ?? 'Not specified';
    final minBudget = filters['minBudget'] ?? 200;
    final maxBudget = filters['maxBudget'] ?? 1000;
    final budget = 'R$minBudget - R$maxBudget';
    final giftType = filters['giftType'] ?? 'Any';
    final category = _formatCategory(filters['category']);
    final giftValue = _formatGiftValue(filters['giftValue']);
    final filterNotes = filters['extraNote'] ?? 'None';
    final refinement = filters['refinement']?.toString().trim() ?? '';

    final profileInfo = '''
    Profile Information:
    - Occasion: $occasion
    - Gender: $gender
    - $age
    - Interests/Likes: $likes
    - Extra Notes: $extraNotes
    ''';

    final filterInfo = '''
    Filter Preferences:
    - Relationship: $relationship
    - Budget: $budget
    - Gift Type: $giftType
    - Gift Category: $category
    - Gift Value: $giftValue
    - Additional Notes: $filterNotes
    - Refinement Instructions: ${refinement.isNotEmpty ? refinement : 'None'}
    ''';

    return '''
    You are a South African gift recommendation assistant.
    Based on the following profile and filter information, generate **exactly 3 personalised gift suggestions** that are locally relevant and available in South Africa.
    Respond in **ZAR currency** and **US English**, do not use z, use s correctly in english words.

    $profileInfo

    $filterInfo

    ${refinement.isNotEmpty ? '''
    IMPORTANT REFINEMENT:
    The user has provided specific feedback or refinement instructions: "$refinement"
    Please carefully consider this feedback and adjust your suggestions accordingly. This refinement should take priority over general preferences.
    
    ''' : ''}Please respond with ONLY a valid JSON array of exactly 3 items, each following this structure:

    [
      {
        "title": "Gift Name",
        "reason": "Why this gift is perfect for this person (15–20 words)",
        "estimatedPrice": 0.00,
        "imageUrl": "https://link-to-gift-image.com/image.jpg",
        "purchaseLink": "https://store-link-or-product-page.com",
        "tags": ["tag1", "tag2", "tag3"],
        "category": "category_name",
        "location": "Suggested store or location (e.g., Takealot, Cape Town, Woolworths, Yuppiechef, local market)"
      }
    ]

    Do not include any text or comments outside the JSON array.

    Requirements:
    - Provide exactly 3 unique suggestions
    - Each suggestion should be thoughtful and personalised based on the profile
    - Price must be within or close to the specified budget (in ZAR)
    - Tags should be relevant keywords (2–5 per suggestion)
    - Categories must be descriptive and relevant
    - Use real or realistic South African stores and brands (e.g., Takealot, Superbalist, Woolworths, Yuppiechef, Typo, NetFlorist, Pick n Pay, local craft markets)
    - Be creative but practical
    ''';
  }


  List<AiGiftSuggestion> _parseAiResponse(String content) {
    try {
      if (content.isEmpty) {
        throw Exception('Empty response content');
      }

      final cleanContent = content.trim();
      final jsonStart = cleanContent.indexOf('[');
      final jsonEnd = cleanContent.lastIndexOf(']') + 1;
      
      String jsonString;
      if (jsonStart >= 0 && jsonEnd > jsonStart) {
        jsonString = cleanContent.substring(jsonStart, jsonEnd);
      } else {
        throw Exception('No valid JSON array found in response');
      }

      final parsed = jsonDecode(jsonString);
      
      if (parsed is List) {
        final suggestions = <AiGiftSuggestion>[];
        
        for (int i = 0; i < parsed.length; i++) {
          try {
            final suggestionData = parsed[i] as Map<String, dynamic>;
            final suggestion = AiGiftSuggestion.fromJson(suggestionData);
            suggestions.add(suggestion);
          } catch (e) {
            print('Error parsing suggestion $i: $e');
            print('Suggestion data: ${parsed[i]}');
            throw Exception('Failed to parse suggestion ${i + 1}: $e');
          }
        }
        
        if (suggestions.isEmpty) {
          throw Exception('No valid suggestions could be parsed from response');
        }
        
        return suggestions;
      } else {
        throw Exception('Expected JSON array, got ${parsed.runtimeType}');
      }
    } catch (e) {
      print('Parse error details: $e');
      print('Raw content length: ${content.length}');
      print('Raw content preview: ${content.length > 500 ? content.substring(0, 500) : content}');
      throw Exception('Failed to parse AI response: $e');
    }
  }

  String _formatGender(dynamic gender) {
    if (gender == null) return 'Not specified';
    if (gender is String) return gender;
    // Handle enum values
    if (gender.toString().contains('GenderType.')) {
      final genderStr = gender.toString().split('.').last;
      switch (genderStr) {
        case 'woman':
          return 'Woman';
        case 'man':
          return 'Man';
        case 'other':
          return 'Other';
        default:
          return 'Not specified';
      }
    }
    return gender.toString();
  }

  String _formatLikes(dynamic likes) {
    if (likes == null) return 'Not specified';
    if (likes is Map) {
      final interests = (likes['interests'] as List?)?.join(', ') ?? '';
      final hobbies = (likes['hobbies'] as List?)?.join(', ') ?? '';
      final likesStr = (likes['likes'] as List?)?.join(', ') ?? '';
      
      final combined = [interests, hobbies, likesStr].where((s) => s.isNotEmpty).join(', ');
      return combined.isNotEmpty ? combined : 'Not specified';
    }
    return likes.toString();
  }

  String _formatCategory(dynamic category) {
    if (category == null) return 'Any';
    if (category.toString().contains('GiftCategory.')) {
      final categoryStr = category.toString().split('.').last;
      switch (categoryStr) {
        case 'tech':
          return 'Technology';
        case 'fashion':
          return 'Fashion';
        case 'home':
          return 'Home & Garden';
        case 'sports':
          return 'Sports & Outdoors';
        case 'books':
          return 'Books & Media';
        case 'toys':
          return 'Toys & Games';
        case 'other':
          return 'Other';
        default:
          return 'Any';
      }
    }
    return category.toString();
  }

  String _formatGiftValue(dynamic giftValue) {
    if (giftValue == null) return 'Any';
    if (giftValue.toString().contains('GiftValue.')) {
      final valueStr = giftValue.toString().split('.').last;
      switch (valueStr) {
        case 'low':
          return 'Budget-Friendly';
        case 'medium':
          return 'Mid-Range';
        case 'high':
          return 'Premium';
        default:
          return 'Any';
      }
    }
    return giftValue.toString();
  }

  void dispose() {
    _httpClient.close();
  }
}