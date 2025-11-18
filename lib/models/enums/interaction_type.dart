import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';

/// Defines the types of interactions users can have with prompts and content.
/// 
/// These interaction types represent different ways users can respond to
/// prompts, requests, or opportunities within the networking platform.
/// Each type has associated UI styling, colors, and button representations.
/// 
/// Example usage:
/// ```dart
/// // Create interaction button
/// InteractionButton(
///   type: InteractionType.thisIsMe,
///   onPressed: () => handleInteraction(),
/// )
/// 
/// // Access interaction properties
/// final color = InteractionType.lookingForThis.color;
/// final title = InteractionType.knowSomeone.buttonTitle;
/// ```
enum InteractionType {
  /// User can provide the requested service/help.
  thisIsMe('this_is_me'),
  
  /// User is looking for this type of service/help.
  lookingForThis('looking_for_this'),
  
  /// User knows someone who can provide this service/help.
  knowSomeone('know_someone'),
  
  /// This prompt/request is not relevant to the user.
  notRelevant('not_relevant');

  const InteractionType(this.value);
  
  final String value;

  /// Creates an [InteractionType] from a JSON string value.
  /// 
  /// Returns [InteractionType.thisIsMe] if the value doesn't match any type.
  static InteractionType fromJson(String value) {
    return InteractionType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => InteractionType.thisIsMe,
    );
  }

  /// Converts this [InteractionType] to a JSON string value.
  String toJson() => value;

  /// Returns the theme color associated with this interaction type.
  ///
  /// Each interaction type has a distinct color for visual differentiation.
  Color get color {
    switch (this) {
      case InteractionType.thisIsMe:
        return AppColors.me;
      case InteractionType.lookingForThis:
        return AppColors.need;
      case InteractionType.knowSomeone:
        return AppColors.know;
      case InteractionType.notRelevant:
        return AppColors.na;
    }
  }

  /// Returns the text color for non-selected button state.
  ///
  /// Uses a neutral dark color for better readability against light backgrounds.
  Color get textColor {
    return const Color(0xFF1E1E1E);
  }

  /// Returns the user-facing button text for this interaction type.
  String buttonTitle(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case InteractionType.thisIsMe:
        return l10n.interactionTypeThisIsMeButton;
      case InteractionType.lookingForThis:
        return l10n.interactionTypeLookingForThisButton;
      case InteractionType.knowSomeone:
        return l10n.interactionTypeKnowSomeoneButton;
      case InteractionType.notRelevant:
        return l10n.interactionTypeNotRelevantButton;
    }
  }

  /// Returns the user-facing button text when matching the same interaction type as the prompt.
  ///
  /// Used in daily prompts to show "This is me too" instead of "This is me" when
  /// the button's interaction type matches the prompt's interaction type.
  String buttonTitleWhenMatchingPrompt(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case InteractionType.thisIsMe:
        return l10n.interactionTypeThisIsMeButtonToo;
      case InteractionType.lookingForThis:
        return l10n.interactionTypeLookingForThisButtonToo;
      case InteractionType.knowSomeone:
        return l10n.interactionTypeKnowSomeoneButtonToo;
      case InteractionType.notRelevant:
        return l10n.interactionTypeNotRelevantButtonToo;
    }
  }

  /// Returns the asset filename for this interaction type's button icon.
  String get buttonName {
    switch (this) {
      case InteractionType.thisIsMe:
        return 'label_me';
      case InteractionType.lookingForThis:
        return 'label_search';
      case InteractionType.knowSomeone:
        return 'label_at';
      case InteractionType.notRelevant:
        return 'label_skip';
    }
  }

  /// Returns the preferred icon alignment for this interaction type's button.
  Alignment get iconPosition {
    switch (this) {
      case InteractionType.thisIsMe:
      case InteractionType.knowSomeone:
        return Alignment.centerRight;
      case InteractionType.lookingForThis:
      case InteractionType.notRelevant:
        return Alignment.centerLeft;
    }
  }

  /// Returns a Material Design icon as fallback when assets are unavailable.
  IconData get fallbackIcon {
    switch (this) {
      case InteractionType.thisIsMe:
        return Icons.person;
      case InteractionType.lookingForThis:
        return Icons.lightbulb;
      case InteractionType.knowSomeone:
        return Icons.handshake;
      case InteractionType.notRelevant:
        return Icons.block;
    }
  }

  /// Returns the complete asset path for this interaction type's icon.
  String get assetPath => 'assets/images/buttons/$buttonName.png';
  
  /// Returns the hint text to display in the content field based on interaction type.
  ///
  /// Provides contextually appropriate prompts to guide users in creating
  /// their cards based on whether they're offering help or seeking help.
  String hintText(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case InteractionType.thisIsMe:
        return l10n.interactionTypeThisIsMeHint;
      case InteractionType.lookingForThis:
        return l10n.interactionTypeLookingForThisHint;
      case InteractionType.knowSomeone:
        return l10n.interactionTypeKnowSomeoneHint;
      case InteractionType.notRelevant:
        return l10n.interactionTypeNotRelevantHint;
    }
  }

  /// Returns the selection title for the interaction type selection screen.
  ///
  /// This is the main title displayed on the selection button.
  String selectionTitle(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case InteractionType.thisIsMe:
        return l10n.interactionTypeThisIsMeSelection;
      case InteractionType.lookingForThis:
        return l10n.interactionTypeLookingForThisSelection;
      case InteractionType.knowSomeone:
        return l10n.interactionTypeKnowSomeoneSelection;
      case InteractionType.notRelevant:
        return l10n.interactionTypeNotRelevantSelection;
    }
  }

  String selectionSubtitle(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case InteractionType.thisIsMe:
        return l10n.interactionTypeThisIsMeSubtitle;
      case InteractionType.lookingForThis:
        return l10n.interactionTypeLookingForThisSubtitle;
      case InteractionType.knowSomeone:
        return l10n.interactionTypeKnowSomeoneSubtitle;
      case InteractionType.notRelevant:
        return l10n.interactionTypeNotRelevantSubtitle;
    }
  }
}