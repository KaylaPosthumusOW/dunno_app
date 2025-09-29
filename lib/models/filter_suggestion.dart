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

  const FilterSuggestion({this.title = '', this.minBudget, this.maxBudget, this.category, this.giftValue, this.giftType, this.extraNote});

  @override
  List<Object?> get props => [title, minBudget, maxBudget, category, giftValue, giftType, extraNote];

  FilterSuggestion copyWith({
    String? title,
    num? minBudget,
    num? maxBudget,
    GiftCategory? category,
    GiftValue? giftValue,
    String? giftType,
    String? extraNote,
  }) {
    return FilterSuggestion(
      title: title ?? this.title,
      minBudget: minBudget ?? this.minBudget,
      maxBudget: maxBudget ?? this.maxBudget,
      category: category ?? this.category,
      giftValue: giftValue ?? this.giftValue,
      giftType: giftType ?? this.giftType,
      extraNote: extraNote ?? this.extraNote,
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
    };
  }

  factory FilterSuggestion.fromMap(Map<String, dynamic> map) {
    return FilterSuggestion(
      title: map['title'] ?? '',
      minBudget: map['minBudget'],
      maxBudget: map['maxBudget'],
      category: map['category'] != null ? GiftCategory.values.firstWhere((e) => e.toString().split('.').last == map['category']) : null,
      giftValue: map['giftValue'] != null ? GiftValue.values.firstWhere((e) => e.toString().split('.').last == map['giftValue']) : null,
      giftType: map['giftType'],
      extraNote: map['extraNote'],
    );
  }
}