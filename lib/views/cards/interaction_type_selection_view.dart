import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../models/enums/interaction_type.dart';
import '../../core/theme/app_fonts.dart';
import '../../core/theme/app_modifiers.dart';
import '../../core/theme/venyu_theme.dart';
import '../../widgets/buttons/action_button.dart';
import '../../models/enums/action_button_type.dart';
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
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    
    return PopScope(
      canPop: !isFromPrompts, // Prevent back swipe if from prompts
      child: PlatformScaffold(
        backgroundColor: venyuTheme.pageBackground,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(flex: 1),
                
                // Title text
                Text(
                  'Make the net work',
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
                  'For you',
                  style: TextStyle(
                    color: venyuTheme.primaryText,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),

                const Spacer(flex: 1),
                
                // "I need this" button
                _InteractionTypeButton(
                  interactionType: InteractionType.lookingForThis,
                  onTap: () => _handleSelection(context, InteractionType.lookingForThis),
                ),
                
                const SizedBox(height: AppModifiers.mediumSpacing),
                
                // "I can help" button
                _InteractionTypeButton(
                  interactionType: InteractionType.thisIsMe,
                  onTap: () => _handleSelection(context, InteractionType.thisIsMe),
                ),
                
                
                const Spacer(flex: 2),
                
                // "Not now" button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: ActionButton(
                    label: 'Not now',
                    type: ActionButtonType.secondary,
                    onPressed: () {
                      if (isFromPrompts) {
                        // For prompts flow: Pop until we're back to the main screen
                        // Pop 3 times: InteractionTypeSelectionView, PromptsView, PromptEntryView
                        Navigator.of(context).pop(); // InteractionTypeSelectionView
                        Navigator.of(context).pop(); // PromptsView  
                        Navigator.of(context).pop(); // PromptEntryView (closes modal)
                      } else {
                        // Normal flow - just close the modal
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ),
                
                const SizedBox(height: 16),
              ],
            ),
          ),
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
    final venyuTheme = context.venyuTheme;
    
    return Container(
      decoration: BoxDecoration(
        color: interactionType.color,
        borderRadius: BorderRadius.circular(AppModifiers.largeRadius),
        border: Border.all(
          color: venyuTheme.borderColor,
          width: AppModifiers.thinBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(4, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppModifiers.largeRadius),
          highlightColor: Colors.white.withValues(alpha: 0.3),
          splashFactory: NoSplash.splashFactory,
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