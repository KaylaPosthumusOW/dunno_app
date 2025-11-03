import 'package:equatable/equatable.dart';

enum GiftValue { low, medium, high }

enum GiftCategory { tech, fashion, home, sports, books, toys, other }

class FilterSuggestion extends Equatable {
  final String title;
  final num? minBudget;
  final num? maxBudget;
  final GiftCategory? category;
  final GiftValue? giftValue;
  final String? giftType;
  final String? extraNote;
  final int? numberOfSuggestions;
  final String? location;

  const FilterSuggestion({
    this.title = '',
    this.minBudget,
    this.maxBudget,
    this.category,
    this.giftValue,
    this.giftType,
    this.extraNote,
    this.numberOfSuggestions,
    this.location,
  });

  @override
  List<Object?> get props => [
    title,
    minBudget,
    maxBudget,
    category,
    giftValue,
    giftType,
    extraNote,
    numberOfSuggestions,
    location,
  ];

  FilterSuggestion copyWith({
    String? title,
    num? minBudget,
    num? maxBudget,
    GiftCategory? category,
    GiftValue? giftValue,
    String? giftType,
    String? extraNote,
    int? numberOfSuggestions,
    String? location,
  }) {
    return FilterSuggestion(
      title: title ?? this.title,
      minBudget: minBudget ?? this.minBudget,
      maxBudget: maxBudget ?? this.maxBudget,
      category: category ?? this.category,
      giftValue: giftValue ?? this.giftValue,
      giftType: giftType ?? this.giftType,
      extraNote: extraNote ?? this.extraNote,
      numberOfSuggestions: numberOfSuggestions ?? this.numberOfSuggestions,
      location: location ?? this.location,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'minBudget': minBudget,
      'maxBudget': maxBudget,
      'category': category?.toString().split('.').last,
      'giftValue': giftValue?.toString().split('.').last,
      'giftType': giftType,
      'extraNote': extraNote,
      'numberOfSuggestions': numberOfSuggestions,
      'location': location,
    };
  }

  factory FilterSuggestion.fromMap(Map<String, dynamic> map) {
    return FilterSuggestion(
      title: map['title'] ?? '',
      minBudget: map['minBudget'],
      maxBudget: map['maxBudget'],
      category: map['category'] != null
          ? GiftCategory.values.firstWhere(
              (e) => e.toString().split('.').last == map['category'],
            )
          : null,
      giftValue: map['giftValue'] != null
          ? GiftValue.values.firstWhere(
              (e) => e.toString().split('.').last == map['giftValue'],
            )
          : null,
      giftType: map['giftType'],
      extraNote: map['extraNote'],
      numberOfSuggestions: map['numberOfSuggestions'],
      location: map['location'],
    );
  }
}
