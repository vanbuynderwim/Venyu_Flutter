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
        return Colors.blue;
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
        return AppColors.primair4Lilac;
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
        return 'Expired';
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
      case PromptStatus.online:
        return '🟢';
      case PromptStatus.offline:
        return '🔴';
    }
  }

  /// Get the status info description for this status
  ///
  /// For online and offline status, provide a Prompt object to include
  /// dynamic date information about expiry and duration.
  String statusInfo([dynamic prompt]) {
    switch (this) {
      case PromptStatus.draft:
        return 'Your card is saved as a draft. Complete and submit it to start getting matches.';
      case PromptStatus.pendingReview:
        return 'Your card is being reviewed by our team. This usually takes 12-24 hours to check if the content follows community guidelines.';
      case PromptStatus.pendingTranslation:
        return 'Your card is being translated to other languages.';
      case PromptStatus.approved:
        return 'Your card has been approved and will go online automatically on your next login.';
      case PromptStatus.rejected:
        return 'Your card was rejected for not following community guidelines. Please edit and resubmit.';
      case PromptStatus.archived:
        return 'Your card has been archived and is no longer visible to other users.';
      case PromptStatus.online:
        return 'Your card is live and visible to other users. You can receive matches.';
      case PromptStatus.offline:
        return 'Your card has expired and is no longer visible to other users.';
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
      case PromptStatus.online:
      case PromptStatus.offline:
      case PromptStatus.pendingTranslation:
        return false;
    }
  }
}