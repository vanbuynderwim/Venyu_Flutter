import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../models/enums/interaction_type.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';
import '../../core/theme/app_layout_styles.dart';
import '../../core/theme/app_modifiers.dart';
import '../../core/theme/venyu_theme.dart';
import '../../widgets/buttons/action_button.dart';
import '../../models/enums/action_button_type.dart';
import '../../core/providers/app_providers.dart';
import '../../core/theme/app_text_styles.dart';
import 'card_detail_view.dart';

/// Initial selection view for choosing interaction type when creating a new card.
/// 
/// This view presents two large, prominent buttons for the user to select
/// whether they need help or can offer help. After selection, it navigates
/// to the CardDetailView with the chosen interaction type.
class InteractionTypeSelectionView extends StatelessWidget {
  /// Whether this view is shown after completing prompts (affects back navigation)
  final bool isFromPrompts;
  
  /// Callback to close the modal when coming from prompts
  final VoidCallback? onCloseModal;
  
  const InteractionTypeSelectionView({
    super.key,
    this.isFromPrompts = false,
    this.onCloseModal,
  });

  void _handleSelection(BuildContext context, InteractionType type) {
    // Provide medium haptic feedback
    HapticFeedback.mediumImpact();
    
    // Navigate to CardDetailView with the selected interaction type
    Navigator.of(context).push(
      platformPageRoute(
        context: context,
        builder: (context) => CardDetailView(
          initialInteractionType: type,
          isNewCard: true,
          isFromPrompts: isFromPrompts,
          onCloseModal: onCloseModal,
        ),
      ),
    );
  }

  /// Get user's first name from profile service
  String _getFirstName(BuildContext context) {
    final profileService = context.profileService;
    final profile = profileService.currentProfile;
    final firstName = profile?.firstName;
    if (firstName != null && firstName.isNotEmpty) {
      return firstName;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    // Always use light theme
    final venyuTheme = VenyuTheme.light;
    final firstName = _getFirstName(context);
    
    return PopScope(
      canPop: !isFromPrompts, // Prevent back swipe if from prompts
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primair4Lilac, // Lilac color - always visible
              Colors.white,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Radar background image (always visible)
            Positioned.fill(
              child: Image.asset(
                'assets/images/visuals/radar.png',
                fit: BoxFit.cover,
                opacity: const AlwaysStoppedAnimation(0.5), // Semi-transparent overlay
                errorBuilder: (context, error, stackTrace) {
                  // If image fails to load, just show the gradient
                  return const SizedBox.shrink();
                },
              ),
            ),
            // Main content
            PlatformScaffold(
              backgroundColor: Colors.transparent,
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                const Spacer(flex: 1),
                
                // Title text
                Text(
                  isFromPrompts 
                    ? 'Thank you${firstName.isNotEmpty ? ' $firstName!' : ''}'
                    : 'Make the net work',
                  style: TextStyle(
                    color: venyuTheme.primaryText,
                    fontSize: 36,
                    fontFamily: AppFonts.graphie,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 8),
                
                // Subtitle text
                Text(
                  isFromPrompts
                    ? "Now, let's make the net work for you"
                    : 'For you',
                  style: TextStyle(
                    color: venyuTheme.primaryText,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),

                const Spacer(flex: 1),
                
                // "I need this" button
                Theme(
                  data: ThemeData.light().copyWith(
                    extensions: [VenyuTheme.light],
                  ),
                  child: _InteractionTypeButton(
                    interactionType: InteractionType.lookingForThis,
                    onTap: () => _handleSelection(context, InteractionType.lookingForThis),
                  ),
                ),
                
                const SizedBox(height: AppModifiers.smallSpacing),
                
                // "I can help" button
                Theme(
                  data: ThemeData.light().copyWith(
                    extensions: [VenyuTheme.light],
                  ),
                  child: _InteractionTypeButton(
                    interactionType: InteractionType.thisIsMe,
                    onTap: () => _handleSelection(context, InteractionType.thisIsMe),
                  ),
                ),
                
                // Disclaimer and guidelines (always visible)
                  const SizedBox(height: 16),
                  // Community guidelines title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Community guidelines',
                      style: AppTextStyles.caption1.copyWith(
                        color: venyuTheme.secondaryText,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Community guidelines
                  Theme(
                    data: ThemeData.light().copyWith(
                      extensions: [VenyuTheme.light],
                    ),
                    child: Builder(
                      builder: (lightContext) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 0),
                        padding: const EdgeInsets.all(16),
                        decoration: AppLayoutStyles.cardDecoration(lightContext),
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Allowed content
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '✅  ',
                              style: TextStyle(fontSize: 20),
                            ),
                            Expanded(
                              child: Text(
                                'networking, sharing knowledge or resources, asking for help, reach out for genuine connections',
                                style: AppTextStyles.footnote.copyWith(
                                  color: venyuTheme.secondaryText,
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        const SizedBox(height: 12),
                        
                        // Prohibited content
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '🚫  ',
                              style: TextStyle(fontSize: 20),
                            ),
                            Expanded(
                              child: Text(
                                'political posts, scams, spam, misleading, offensive or explicit content, advertising or sales pitches',
                                style: AppTextStyles.footnote.copyWith(
                                  color: venyuTheme.secondaryText,
                                ),
                              ),
                            ),
                          ],
                        ),
                        ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),
                  // Disclaimer text
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'All cards are reviewed before going live',
                      style: AppTextStyles.caption1.copyWith(
                        color: venyuTheme.secondaryText,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                
                Spacer(flex: 1),
                
                // "Not now" button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Theme(
                    data: ThemeData.light().copyWith(
                      extensions: [VenyuTheme.light],
                    ),
                    child: ActionButton(
                      label: 'Not now',
                      type: ActionButtonType.secondary,
                      onPressed: () {
                        if (isFromPrompts && onCloseModal != null) {
                          // Use the callback to close the modal
                          onCloseModal!();
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Individual button widget for interaction type selection.
class _InteractionTypeButton extends StatelessWidget {
  final InteractionType interactionType;
  final VoidCallback onTap;

  const _InteractionTypeButton({
    required this.interactionType,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
       
    return Container(
      decoration: BoxDecoration(
        color: interactionType.color,
        borderRadius: BorderRadius.circular(AppModifiers.largeRadius),
        
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppModifiers.largeRadius),
          highlightColor: Colors.white.withValues(alpha: 0.2),
          splashFactory: InkSplash.splashFactory,
          child: Padding(
            padding: const EdgeInsets.all(AppModifiers.largeSpacing),
            child: Row(
            children: [
              // Icon asset image
              Image.asset(
                interactionType.assetPath,
                width: 36,
                height: 36,
                color: Colors.white,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to icon if asset fails
                  return Icon(
                    interactionType.fallbackIcon,
                    color: Colors.white,
                    size: 28,
                  );
                },
              ),
              
              const SizedBox(width: AppModifiers.mediumSpacing),
              
              // Text content from InteractionType
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      interactionType.selectionTitle,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      interactionType.selectionSubtitle,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Chevron icon asset
              Image.asset(
                'assets/images/icons/chevron_regular.png',
                width: 24,
                height: 24,
                color: Colors.white,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to icon if asset fails
                  return Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                    size: 24,
                  );
                },
              ),
            ],
            ),
          ),
        ),
      ),
    );
  }
}