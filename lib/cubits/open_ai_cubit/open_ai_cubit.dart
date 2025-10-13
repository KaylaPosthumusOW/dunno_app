import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dunno/models/collections.dart';
import 'package:dunno/models/filter_suggestion.dart';
import 'package:dunno/models/ai_gift_suggestion.dart';
import 'package:dunno/services/openai_client.dart';
import 'open_ai_state.dart';

class OpenAiCubit extends Cubit<OpenAiState> {
  final OpenAiClient _openAiClient;

  OpenAiCubit(this._openAiClient) : super(const OpenAiInitial());

  /// Select a collection for gift suggestions
  void selectCollection(Collections collection) {
    emit(OpenAiCollectionSelected(selectedCollection: collection));
  }

  /// Apply filters to the currently selected collection
  void applyFilters(FilterSuggestion filters) {
    final currentState = state;
    
    if (currentState is OpenAiCollectionSelected) {
      emit(OpenAiFiltersApplied(
        selectedCollection: currentState.selectedCollection,
        appliedFilters: filters,
      ));
    } else if (currentState is OpenAiFiltersApplied) {
      emit(OpenAiFiltersApplied(
        selectedCollection: currentState.selectedCollection,
        appliedFilters: filters,
      ));
    } else if (currentState is OpenAiSuggestionsLoaded) {
      emit(OpenAiFiltersApplied(
        selectedCollection: currentState.selectedCollection,
        appliedFilters: filters,
      ));
    } else {
      emit(OpenAiError(
        message: 'Please select a collection before applying filters',
        errorCode: 'NO_COLLECTION_SELECTED',
      ));
    }
  }

  /// Generate gift suggestions based on current state
  Future<void> generateSuggestions() async {
    final currentState = state;
    
    Collections? selectedCollection;
    FilterSuggestion? appliedFilters;
    
    if (currentState is OpenAiCollectionSelected) {
      selectedCollection = currentState.selectedCollection;
    } else if (currentState is OpenAiFiltersApplied) {
      selectedCollection = currentState.selectedCollection;
      appliedFilters = currentState.appliedFilters;
    } else if (currentState is OpenAiSuggestionsLoaded) {
      selectedCollection = currentState.selectedCollection;
      appliedFilters = currentState.appliedFilters;
    } else {
      emit(const OpenAiError(
        message: 'Please select a collection before generating suggestions',
        errorCode: 'NO_COLLECTION_SELECTED',
      ));
      return;
    }

    try {
      emit(OpenAiGenerating(
        selectedCollection: selectedCollection,
        appliedFilters: appliedFilters,
      ));

      final prompt = _buildPrompt(selectedCollection, appliedFilters);
      
      final response = await _openAiClient.sendResponsesGeneration(
        model: 'gpt-3.5-turbo',
        prompt: prompt,
        maxTokens: 1500,
      );

      final suggestions = _parseAiResponse(response);
      
      emit(OpenAiSuggestionsLoaded(
        suggestions: suggestions,
        selectedCollection: selectedCollection,
        appliedFilters: appliedFilters,
      ));
    } catch (error) {
      emit(OpenAiError(
        message: 'Failed to generate gift suggestions: ${error.toString()}',
        errorCode: 'GENERATION_FAILED',
        selectedCollection: selectedCollection,
        appliedFilters: appliedFilters,
      ));
    }
  }

  /// Clear all selections and return to initial state
  void clearSelections() {
    emit(const OpenAiInitial());
  }

  /// Retry suggestion generation after error
  Future<void> retryGeneration() async {
    final currentState = state;
    
    if (currentState is OpenAiError) {
      if (currentState.selectedCollection != null) {
        emit(OpenAiFiltersApplied(
          selectedCollection: currentState.selectedCollection!,
          appliedFilters: currentState.appliedFilters ?? const FilterSuggestion(),
        ));
        await generateSuggestions();
      } else {
        emit(const OpenAiError(
          message: 'Cannot retry without a selected collection',
          errorCode: 'NO_COLLECTION_FOR_RETRY',
        ));
      }
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
  List<AiGiftSuggestion> _parseAiResponse(Map<String, dynamic> response) {
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
          .map((suggestion) => AiGiftSuggestion.fromJson(suggestion as Map<String, dynamic>))
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

  /// Get the current selected collection from state
  Collections? get selectedCollection {
    final currentState = state;
    if (currentState is OpenAiCollectionSelected) {
      return currentState.selectedCollection;
    } else if (currentState is OpenAiFiltersApplied) {
      return currentState.selectedCollection;
    } else if (currentState is OpenAiGenerating) {
      return currentState.selectedCollection;
    } else if (currentState is OpenAiSuggestionsLoaded) {
      return currentState.selectedCollection;
    } else if (currentState is OpenAiError) {
      return currentState.selectedCollection;
    }
    return null;
  }

  /// Get the current applied filters from state
  FilterSuggestion? get appliedFilters {
    final currentState = state;
    if (currentState is OpenAiFiltersApplied) {
      return currentState.appliedFilters;
    } else if (currentState is OpenAiGenerating) {
      return currentState.appliedFilters;
    } else if (currentState is OpenAiSuggestionsLoaded) {
      return currentState.appliedFilters;
    } else if (currentState is OpenAiError) {
      return currentState.appliedFilters;
    }
    return null;
  }

  /// Get the current suggestions from state
  List<AiGiftSuggestion>? get suggestions {
    final currentState = state;
    if (currentState is OpenAiSuggestionsLoaded) {
      return currentState.suggestions;
    }
    return null;
  }

  /// Get a single suggestion by index
  AiGiftSuggestion? getSuggestionAt(int index) {
    final currentSuggestions = suggestions;
    if (currentSuggestions != null && 
        index >= 0 && 
        index < currentSuggestions.length) {
      return currentSuggestions[index];
    }
    return null;
  }
}
