import 'package:flutter/material.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_modifiers.dart';
import '../../core/theme/venyu_theme.dart';
import '../../models/match.dart';
import '../../models/profile.dart';
import '../../widgets/common/avatar_view.dart';

/// MatchOverviewHeader - Shows "You" vs match profile comparison header
/// 
/// This widget displays a comparison header showing the current user's avatar
/// and name on the left, and the match's avatar and name on the right.
/// Used above the matching cards section to provide context about whose
/// cards are being compared.
/// 
/// Based on iOS MatchOverviewHeader with Flutter Material Design styling.
class MatchOverviewHeader extends StatelessWidget {
  /// The match being displayed
  final Match match;
  
  /// Current user's profile
  final Profile currentProfile;
  
  /// Whether the user has Pro subscription or is connected with this match
  final bool? isPro;

  /// Creates a [MatchOverviewHeader] widget.
  const MatchOverviewHeader({
    super.key,
    required this.match,
    required this.currentProfile,
    this.isPro,
  });

  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppModifiers.defaultRadius),
          topRight: Radius.circular(AppModifiers.defaultRadius),
        ),
        border: Border.all(
          color: venyuTheme.borderColor,
          width: AppModifiers.extraThinBorder,
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Left avatar (current user)
            Container(
              width: 60,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: venyuTheme.cardBackground,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppModifiers.defaultRadius),
                ),
              ),
              child: Center(
                child: AvatarView(
                  avatarId: currentProfile.avatarID,
                  size: 40,
                ),
              ),
            ),
            
            // Center content
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: venyuTheme.cardBackground,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'You',
                      style: AppTextStyles.subheadline.copyWith(
                        color: venyuTheme.primaryText,
                      ),
                    ),
                    Text(
                      match.profile_1.firstName,
                      style: AppTextStyles.subheadline.copyWith(
                        color: venyuTheme.primaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Right avatar (match profile)
            Container(
              width: 60,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: venyuTheme.cardBackground,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(AppModifiers.defaultRadius),
                ),
              ),
              child: Center(
                child: AvatarView(
                  avatarId: match.profile_1.avatarID,
                  size: 40,
                  shouldBlur: isPro == false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}