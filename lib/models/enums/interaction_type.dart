import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

enum InteractionType {
  thisIsMe('this_is_me'),
  lookingForThis('looking_for_this'),
  knowSomeone('know_someone'),
  notRelevant('not_relevant');

  const InteractionType(this.value);
  
  final String value;

  static InteractionType fromJson(String value) {
    return InteractionType.values.firstWhere(
      (type) => type.value == value,
      orElse: () => InteractionType.thisIsMe,
    );
  }

  String toJson() => value;

  /// Get the color for this interaction type
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

  /// Get the button title for this interaction type
  String get buttonTitle {
    switch (this) {
      case InteractionType.thisIsMe:
        return 'I can help';
      case InteractionType.lookingForThis:
        return 'I need this';
      case InteractionType.knowSomeone:
        return 'I can refer';
      case InteractionType.notRelevant:
        return 'Not relevant';
    }
  }

  /// Get the button asset name for this interaction type
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

  /// Get the icon position for this interaction type
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

  /// Get the fallback Material icon for this interaction type
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

  /// Get the full asset path for this interaction type
  String get assetPath => 'assets/images/icons/$buttonName.png';
}