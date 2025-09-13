import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/venyu_theme.dart';

enum PromptStatus {
  draft('draft'),
  pendingReview('pending_review'),
  pendingTranslation('pending_translation'),
  approved('approved'),
  rejected('rejected'),
  archived('archived'),
  online('online'),
  offline('offline');

  const PromptStatus(this.value);
  
  final String value;

  static PromptStatus fromJson(String value) {
    return PromptStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => PromptStatus.draft,
    );
  }

  String toJson() => value;

  /// Get the background color for this status - always uses tagBackground from theme
  Color backgroundColor(BuildContext context) {
    return context.venyuTheme.tagBackground;
  }

  /// Get the border color for this status
  Color get borderColor {
    switch (this) {
      case PromptStatus.draft:
        return AppColors.secundair5Pinball;
      case PromptStatus.pendingReview:
        return AppColors.accent2Coral;
      case PromptStatus.pendingTranslation:
        return AppColors.primair4Lilac;
      case PromptStatus.approved:
        return AppColors.me;
      case PromptStatus.rejected:
        return AppColors.na;
      case PromptStatus.archived:
        return AppColors.secundair4Quicksilver;
      case PromptStatus.online:
        return AppColors.me;
      case PromptStatus.offline:
        return AppColors.na;
    }
  }

  /// Get the text color for this status
  Color get textColor {
    switch (this) {
      case PromptStatus.draft:
        return AppColors.secundair3Slategray;
      case PromptStatus.pendingReview:
        return AppColors.accent1Tangerine;
      case PromptStatus.pendingTranslation:
        return AppColors.primair3Berry;
      case PromptStatus.approved:
        return AppColors.me;
      case PromptStatus.rejected:
        return AppColors.na;
      case PromptStatus.archived:
        return AppColors.secundair3Slategray;
      case PromptStatus.online:
        return AppColors.me;
      case PromptStatus.offline:
        return AppColors.na;
    }
  }

  /// Get the display text for this status
  String get displayText {
    switch (this) {
      case PromptStatus.draft:
        return 'Draft';
      case PromptStatus.pendingReview:
        return 'Pending Review';
      case PromptStatus.pendingTranslation:
        return 'Pending Translation';
      case PromptStatus.approved:
        return 'Approved';
      case PromptStatus.rejected:
        return 'Rejected';
      case PromptStatus.archived:
        return 'Archived';
      case PromptStatus.online:
        return 'Online';
      case PromptStatus.offline:
        return 'Offline';
    }
  }
}