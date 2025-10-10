import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/venyu_theme.dart';

enum PromptStatus {
  draft('draft'),
  pendingReview('pending_review'),
  pendingTranslation('pending_translation'),
  approved('approved'),
  rejected('rejected'),
  archived('archived');

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
    return context.venyuTheme.adaptiveBackground;
  }

  /// Get the border color for this status
  Color get borderColor {
    switch (this) {
      case PromptStatus.draft:
        return AppColors.secundair5Pinball;
      case PromptStatus.pendingReview:
        return Colors.blue;
      case PromptStatus.pendingTranslation:
        return AppColors.primair4Lilac;
      case PromptStatus.approved:
        return AppColors.me;
      case PromptStatus.rejected:
        return AppColors.na;
      case PromptStatus.archived:
        return AppColors.secundair4Quicksilver;
    }
  }

  /// Get the text color for this status
  Color get textColor {
    switch (this) {
      case PromptStatus.draft:
        return AppColors.secundair3Slategray;
      case PromptStatus.pendingReview:
        return AppColors.primair4Lilac;
      case PromptStatus.pendingTranslation:
        return AppColors.primair3Berry;
      case PromptStatus.approved:
        return AppColors.me;
      case PromptStatus.rejected:
        return AppColors.na;
      case PromptStatus.archived:
        return AppColors.secundair3Slategray;
    }
  }

  /// Get the display text for this status
  String displayText(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case PromptStatus.draft:
        return l10n.promptStatusDraftDisplay;
      case PromptStatus.pendingReview:
        return l10n.promptStatusPendingReviewDisplay;
      case PromptStatus.pendingTranslation:
        return l10n.promptStatusPendingTranslationDisplay;
      case PromptStatus.approved:
        return l10n.promptStatusApprovedDisplay;
      case PromptStatus.rejected:
        return l10n.promptStatusRejectedDisplay;
      case PromptStatus.archived:
        return l10n.promptStatusArchivedDisplay;
    }
  }

  /// Get the emoji for this status
  String get emoji {
    switch (this) {
      case PromptStatus.draft:
        return '📝';
      case PromptStatus.pendingReview:
        return '🕙';
      case PromptStatus.pendingTranslation:
        return '🌐';
      case PromptStatus.approved:
        return '✅';
      case PromptStatus.rejected:
        return '🚫';
      case PromptStatus.archived:
        return '📦';
    }
  }

  /// Get the status info description for this status
  String statusInfo(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (this) {
      case PromptStatus.draft:
        return l10n.promptStatusDraftInfo;
      case PromptStatus.pendingReview:
        return l10n.promptStatusPendingReviewInfo;
      case PromptStatus.pendingTranslation:
        return l10n.promptStatusPendingTranslationInfo;
      case PromptStatus.approved:
        return l10n.promptStatusApprovedInfo;
      case PromptStatus.rejected:
        return l10n.promptStatusRejectedInfo;
      case PromptStatus.archived:
        return l10n.promptStatusArchivedInfo;
    }
  }


  /// Check if the edit button should be enabled for this status
  bool get canEdit {
    switch (this) {
      case PromptStatus.draft:
      case PromptStatus.rejected:
        return true;
      case PromptStatus.pendingReview:
      case PromptStatus.approved:
      case PromptStatus.archived:
      case PromptStatus.pendingTranslation:
        return false;
    }
  }
}