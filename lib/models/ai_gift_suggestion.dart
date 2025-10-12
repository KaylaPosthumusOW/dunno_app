import 'package:equatable/equatable.dart';

/// Model for individual AI-generated gift suggestion cards
class AiGiftSuggestion extends Equatable {
  final String title;
  final String description;
  final String reason;
  final double estimatedPrice;
  final String? imageUrl;
  final String? purchaseLink;
  final List<String> tags;
  final String category;

  const AiGiftSuggestion({
    required this.title,
    required this.description,
    required this.reason,
    required this.estimatedPrice,
    this.imageUrl,
    this.purchaseLink,
    required this.tags,
    required this.category,
  });

  @override
  List<Object?> get props => [
        title,
        description,
        reason,
        estimatedPrice,
        imageUrl,
        purchaseLink,
        tags,
        category,
      ];

  factory AiGiftSuggestion.fromJson(Map<String, dynamic> json) {
    return AiGiftSuggestion(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      reason: json['reason'] ?? '',
      estimatedPrice: (json['estimatedPrice'] ?? 0).toDouble(),
      imageUrl: json['imageUrl'],
      purchaseLink: json['purchaseLink'],
      tags: List<String>.from(json['tags'] ?? []),
      category: json['category'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'reason': reason,
      'estimatedPrice': estimatedPrice,
      'imageUrl': imageUrl,
      'purchaseLink': purchaseLink,
      'tags': tags,
      'category': category,
    };
  }

  AiGiftSuggestion copyWith({
    String? title,
    String? description,
    String? reason,
    double? estimatedPrice,
    String? imageUrl,
    String? purchaseLink,
    List<String>? tags,
    String? category,
  }) {
    return AiGiftSuggestion(
      title: title ?? this.title,
      description: description ?? this.description,
      reason: reason ?? this.reason,
      estimatedPrice: estimatedPrice ?? this.estimatedPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      purchaseLink: purchaseLink ?? this.purchaseLink,
      tags: tags ?? this.tags,
      category: category ?? this.category,
    );
  }
}