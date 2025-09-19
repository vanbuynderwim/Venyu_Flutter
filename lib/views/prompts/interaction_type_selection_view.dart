import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/enums/interaction_type.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';
import '../../core/theme/app_layout_styles.dart';
import '../../core/theme/app_modifiers.dart';
import '../../core/theme/venyu_theme.dart';
import '../../widgets/buttons/action_button.dart';
import '../../widgets/common/radar_background_overlay.dart';
import '../../widgets/common/community_guidelines_widget.dart';
import '../../models/enums/action_button_type.dart';
import '../../core/providers/app_providers.dart';
import '../../core/theme/app_text_styles.dart';
import '../../widgets/common/info_box_widget.dart';
import 'prompt_edit_view.dart';

/// Initial selection view for choosing interaction type when creating a new card.
///
/// This view presents two large, prominent buttons for the user to select
/// whether they need help or can offer help. After selection, it navigates
/// to the CardEditView with the chosen interaction type.
class InteractionTypeSelectionView extends StatelessWidget {
  /// Whether this view is shown after completing prompts (affects back navigation)
  final bool isFromPrompts;

  /// Callback to close the modal when coming from prompts
  final VoidCallback? onCloseModal;

  /// Optional venue ID to associate with the new prompt
  final String? venueId;

  const InteractionTypeSelectionView({
    super.key,
    this.isFromPrompts = false,
    this.onCloseModal,
    this.venueId,
  });

  void _handleSelection(BuildContext context, InteractionType type) async {
    // Provide medium haptic feedback
    HapticFeedback.mediumImpact();

    // Navigate to CardEditView with the selected interaction type
    final result = await Navigator.of(context).push<bool>(
      platformPageRoute(
        context: context,
        builder: (context) => PromptEditView(
          initialInteractionType: type,
          isNewPrompt: true,
          isFromPrompts: isFromPrompts,
          onCloseModal: onCloseModal,
          venueId: venueId,
        ),
      ),
    );

    // If the prompt was successfully saved, close the entire modal
    if (result == true && context.mounted) {
      Navigator.of(context).pop(true);
    }
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

    final venyuTheme = context.venyuTheme;
    final firstName = _getFirstName(context);
    
    return PopScope(
      canPop: !isFromPrompts, // Prevent back swipe if from prompts
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              venyuTheme.gradientPrimary, 
              venyuTheme.adaptiveBackground,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Radar background overlay
            const RadarBackgroundOverlay(),
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
                    color: venyuTheme.darkText,
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
                    color: venyuTheme.darkText,
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
                
                // Community guidelines
                const SizedBox(height: 16),
                CommunityGuidelinesWidget(
                  showTitle: false,
                ),

                  const SizedBox(height: 8),
                  // Disclaimer text
                  InfoBoxWidget(
                        text: 'All cards are subject to review before going live',
                      ),
                
                Spacer(flex: 2),
                
                // "Not now" button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: ActionButton(
                      label: 'Not now',
                      type: ActionButtonType.secondary,
                      onInvertedBackground: true,
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
                
                //const SizedBox(height: 16),
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