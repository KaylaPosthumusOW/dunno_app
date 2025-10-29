import 'package:equatable/equatable.dart';

class AiGiftSuggestion extends Equatable {
  final String title;
  final String reason;
  final double estimatedPrice;
  final String? imageUrl;
  final String? purchaseLink;
  final List<String> tags;
  final String category;
  final String? location;

  const AiGiftSuggestion({
    required this.title,
    required this.reason,
    required this.estimatedPrice,
    this.imageUrl,
    this.purchaseLink,
    required this.tags,
    required this.category,
    this.location,
  });

  @override
  List<Object?> get props => [title, reason, estimatedPrice, imageUrl, purchaseLink, tags, category, location,];

  AiGiftSuggestion copyWith({
    String? title,
    String? reason,
    double? estimatedPrice,
    String? imageUrl,
    String? purchaseLink,
    List<String>? tags,
    String? category,
    String? location,
  }) {
    return AiGiftSuggestion(
      title: title ?? this.title,
      reason: reason ?? this.reason,
      estimatedPrice: estimatedPrice ?? this.estimatedPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      purchaseLink: purchaseLink ?? this.purchaseLink,
      tags: tags ?? this.tags,
      category: category ?? this.category,
      location: location ?? this.location,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'reason': reason,
      'estimatedPrice': estimatedPrice,
      'imageUrl': imageUrl,
      'purchaseLink': purchaseLink,
      'tags': tags,
      'category': category,
      'location': location,
    };
  }

  factory AiGiftSuggestion.fromJson(Map<String, dynamic> json) {
    return AiGiftSuggestion(
      title: json['title'] ?? '',
      reason: json['reason'] ?? '',
      estimatedPrice: (json['estimatedPrice'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl'],
      purchaseLink: json['purchaseLink'],
      tags: List<String>.from(json['tags'] ?? []),
      category: json['category'] ?? '',
      location: json['location'],
    );
  }
}