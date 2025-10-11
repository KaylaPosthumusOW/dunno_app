import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dunno/models/collections.dart';
import 'package:dunno/models/filter_suggestion.dart';
import 'package:dunno/services/openai_client.dart';
import 'open_ai_state.dart';

class OpenAiCubit extends Cubit<OpenAiState> {
  final OpenAiClient _openAiClient;
  
  Collections? _selectedCollection;
  FilterSuggestion? _appliedFilters;

  OpenAiCubit({required OpenAiClient openAiClient})
      : _openAiClient = openAiClient,
        super(OpenAiInitial());

  Collections? get selectedCollection => _selectedCollection;
  FilterSuggestion? get appliedFilters => _appliedFilters;

  /// Set the selected collection for gift suggestions
  void setSelectedCollection(Collections collection) {
    _selectedCollection = collection;
    if (_appliedFilters != null) {
      emit(OpenAiFiltersApplied(
        selectedCollection: _selectedCollection,
        appliedFilters: _appliedFilters!,
      ));
    }
  }

  /// Apply filters for gift suggestions
  void applyFilters(FilterSuggestion filters) {
    _appliedFilters = filters;
    emit(OpenAiFiltersApplied(
      selectedCollection: _selectedCollection,
      appliedFilters: filters,
    ));
  }

  /// Clear all selections and filters
  void clearSelections() {
    _selectedCollection = null;
    _appliedFilters = null;
    emit(OpenAiInitial());
  }

  /// Generate gift suggestions based on selected collection and filters
  Future<void> generateGiftSuggestions() async {
    if (_selectedCollection == null) {
      emit(const OpenAiError(
        message: 'Please select a collection first',
        errorCode: 'NO_COLLECTION',
      ));
      return;
    }

    try {
      emit(const OpenAiLoading(loadingMessage: 'Generating gift suggestions...'));

      final prompt = _buildPrompt(_selectedCollection!, _appliedFilters);
      
      final response = await _openAiClient.sendResponsesGeneration(
        model: 'gpt-3.5-turbo',
        prompt: prompt,
        maxTokens: 1500,
      );

      final suggestions = _parseAiResponse(response);
      
      emit(OpenAiGiftSuggestionsLoaded(
        suggestions: suggestions,
        selectedCollection: _selectedCollection,
        appliedFilters: _appliedFilters,
      ));
    } catch (error) {
      emit(OpenAiError(
        message: 'Failed to generate gift suggestions: ${error.toString()}',
        errorCode: 'GENERATION_ERROR',
      ));
    }
  }

  /// Build the prompt for OpenAI based on collection and filters
  String _buildPrompt(Collections collection, FilterSuggestion? filters) {
    final collectionInfo = '''
Collection Details:
- Title: ${collection.title ?? 'Untitled Collection'}
- Owner: ${collection.owner?.name ?? 'Unknown'} ${collection.owner?.surname ?? ''}
- Event Date: ${collection.eventCollectionDate?.toDate().toString() ?? 'No date specified'}
''';

    final filterInfo = filters != null ? '''
Filter Preferences:
- Budget Range: ${filters.minBudget != null ? '\$${filters.minBudget}' : 'No min'} - ${filters.maxBudget != null ? '\$${filters.maxBudget}' : 'No max'}
- Category: ${filters.category?.toString().split('.').last ?? 'Any'}
- Gift Value: ${filters.giftValue?.toString().split('.').last ?? 'Any'}
- Gift Type: ${filters.giftType ?? 'Any type'}
- Extra Notes: ${filters.extraNote ?? 'None'}
''' : 'No specific filters applied.';

    return '''
You are a professional gift suggestion assistant. Based on the following collection and filter information, provide exactly 3 thoughtful gift suggestions.

$collectionInfo

$filterInfo

Please respond with a valid JSON object in this exact format:
{
  "suggestions": [
    {
      "title": "Gift Name",
      "description": "Detailed description of the gift (50-100 words)",
      "reason": "Why this gift is perfect for this person/occasion (30-50 words)",
      "estimatedPrice": 0.0,
      "imageUrl": null,
      "purchaseLink": null,
      "tags": ["tag1", "tag2", "tag3"],
      "category": "category_name"
    }
  ]
}

Requirements:
- Provide exactly 3 unique suggestions
- Each suggestion should be thoughtful and personalized
- Price should be within the specified budget range if provided
- Tags should be relevant keywords (3-5 per suggestion)
- Categories should match the filter category if specified
- Be creative but practical
- Consider the event date and collection context
''';
  }

  /// Parse the AI response and extract gift suggestions
  List<GiftSuggestionCard> _parseAiResponse(Map<String, dynamic> response) {
    try {
      // Extract the content from the OpenAI response
      final content = response['choices']?[0]?['message']?['content'] ?? 
                    response['content'] ?? 
                    response.toString();
      
      // Parse JSON from the content
      final Map<String, dynamic> parsedContent;
      if (content is String) {
        // Clean the content and extract JSON
        final cleanContent = content.trim();
        final jsonStart = cleanContent.indexOf('{');
        final jsonEnd = cleanContent.lastIndexOf('}') + 1;
        
        if (jsonStart >= 0 && jsonEnd > jsonStart) {
          final jsonString = cleanContent.substring(jsonStart, jsonEnd);
          parsedContent = jsonDecode(jsonString);
        } else {
          throw Exception('No valid JSON found in response');
        }
      } else {
        parsedContent = content as Map<String, dynamic>;
      }

      final suggestionsData = parsedContent['suggestions'] as List<dynamic>?;
      
      if (suggestionsData == null || suggestionsData.isEmpty) {
        throw Exception('No suggestions found in response');
      }

      final suggestions = suggestionsData
          .map((suggestion) => GiftSuggestionCard.fromJson(suggestion as Map<String, dynamic>))
          .toList();

      // Ensure we have exactly 3 suggestions
      if (suggestions.length < 3) {
        throw Exception('Expected 3 suggestions, got ${suggestions.length}');
      }

      return suggestions.take(3).toList();
    } catch (error) {
      throw Exception('Failed to parse AI response: $error');
    }
  }

  /// Regenerate suggestions with the same parameters
  Future<void> regenerateSuggestions() async {
    if (_selectedCollection != null) {
      await generateGiftSuggestions();
    }
  }

  /// Get a single suggestion by index
  GiftSuggestionCard? getSuggestionAt(int index) {
    final currentState = state;
    if (currentState is OpenAiGiftSuggestionsLoaded && 
        index >= 0 && 
        index < currentState.suggestions.length) {
      return currentState.suggestions[index];
    }
    return null;
  }
}
