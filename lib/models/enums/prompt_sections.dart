import '../../widgets/common/section_type.dart';

/// Defines the different sections available in prompt detail views.
///
/// Each section represents a distinct area of prompt-related content
/// that can be displayed in prompt detail interfaces. Implements [SectionType]
/// to provide consistent section behavior across the app.
///
/// Example usage:
/// ```dart
/// // Display section title
/// Text(PromptSections.card.title); // "Card"
///
/// // Access section description
/// final description = PromptSections.stats.description;
///
/// // Get section icon
/// Icon(PromptSections.intro.icon);
/// ```
enum PromptSections implements SectionType {

  intro,
  /// The prompt card itself with full details.
  card,

  /// Statistics and analytics for this prompt.
  stats;

  /// Introductions and matches from this prompt.


  @override
  String get id => name;

  /// Returns the display title for this prompt section.
  @override
  String get title {
    switch (this) {
      case PromptSections.card:
        return 'Card';
      case PromptSections.stats:
        return 'Stats';
      case PromptSections.intro:
        return 'Intros';
    }
  }

  /// Returns a brief description of this prompt section's content.
  @override
  String get description {
    switch (this) {
      case PromptSections.card:
        return 'View your card details';
      case PromptSections.stats:
        return 'Performance and analytics';
      case PromptSections.intro:
        return 'Matches and introductions';
    }
  }

  /// Returns the icon identifier for this prompt section.
  @override
  String get icon {
    switch (this) {
      case PromptSections.card:
        return 'card';
      case PromptSections.stats:
        return 'grow';
      case PromptSections.intro:
        return 'handshake';
    }
  }
}