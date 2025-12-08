import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../l10n/app_localizations.dart';
import '../../models/enums/interaction_type.dart';
import '../../core/theme/app_fonts.dart';
import '../../core/theme/app_modifiers.dart';
import '../../core/theme/venyu_theme.dart';
import '../../widgets/buttons/action_button.dart';
import '../../widgets/common/radar_background_overlay.dart';
import '../../widgets/common/community_guidelines_widget.dart';
import '../../models/enums/action_button_type.dart';
import 'prompt_edit_view.dart';

/// Initial selection view for choosing interaction type when creating a new card.
///
/// This view presents two large, prominent buttons for the user to select
/// whether they need help or can offer help. After selection, it navigates
/// to the CardEditView with the chosen interaction type.
class InteractionTypeSelectionView extends StatefulWidget {
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

  @override
  State<InteractionTypeSelectionView> createState() => _InteractionTypeSelectionViewState();
}

class _InteractionTypeSelectionViewState extends State<InteractionTypeSelectionView> {
  bool _showGuidelines = false;

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
          isFromPrompts: widget.isFromPrompts,
          onCloseModal: widget.onCloseModal,
          venueId: widget.venueId,
        ),
      ),
    );

    // If the prompt was successfully saved, close the entire modal
    if (result == true && context.mounted) {
      Navigator.of(context).pop(true);
    }
  }

  void _toggleGuidelines() {
    setState(() {
      _showGuidelines = !_showGuidelines;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final venyuTheme = context.venyuTheme;
    
    return PopScope(
      canPop: !widget.isFromPrompts, // Prevent back swipe if from prompts
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
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight - 32, // Account for padding
                        ),
                        child: IntrinsicHeight(
                          child: Column(
                            children: [
                const SizedBox(height: 32),

                // Title text
                Text(
                  l10n.interactionTypeSelectionTitleDefault,
                  style: TextStyle(
                    color: venyuTheme.darkText,
                    fontSize: 32,
                    fontFamily: AppFonts.graphie,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                // Subtitle text
                Text(
                  l10n.interactionTypeSelectionSubtitleDefault,
                  style: TextStyle(
                    color: venyuTheme.darkText,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),
                
                // "I can help" button (This is me - now first)
                Theme(
                  data: ThemeData.light().copyWith(
                    extensions: [VenyuTheme.light],
                  ),
                  child: _InteractionTypeButton(
                    interactionType: InteractionType.thisIsMe,
                    onTap: () => _handleSelection(context, InteractionType.thisIsMe),
                  ),
                ),
                
                // Private prompts info text under "This is me" button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Text(
                    l10n.interactionTypeSelectionPrivatePromptsInfo,
                    style: TextStyle(
                      color: venyuTheme.darkText,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                
                const SizedBox(height: AppModifiers.smallSpacing),
                
                // "I need this" button (now second)
                Theme(
                  data: ThemeData.light().copyWith(
                    extensions: [VenyuTheme.light],
                  ),
                  child: _InteractionTypeButton(
                    interactionType: InteractionType.lookingForThis,
                    onTap: () => _handleSelection(context, InteractionType.lookingForThis),
                  ),
                ),

                const SizedBox(height: 16),

                // Disclaimer text with clickable community guidelines
                GestureDetector(
                  onTap: _toggleGuidelines,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          color: venyuTheme.darkText,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: l10n.interactionTypeSelectionDisclaimerBeforeLinkText,
                          ),
                          TextSpan(
                            text: l10n.interactionTypeSelectionDisclaimerLinkText,
                            style: const TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Community guidelines (expandable)
                if (_showGuidelines) ...[
                  const SizedBox(height: 24),
                  CommunityGuidelinesWidget(
                    showTitle: false,
                  ),
                ],

                const Spacer(),

                // "Not now" button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: ActionButton(
                      label: l10n.interactionTypeSelectionNotNowButton,
                      type: ActionButtonType.secondary,
                      onInvertedBackground: true,
                      onPressed: () {
                        if (widget.isFromPrompts && widget.onCloseModal != null) {
                          // Use the callback to close the entire modal
                          widget.onCloseModal!();
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
                    );
                  },
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
            padding: const EdgeInsets.all(AppModifiers.mediumSpacing),
            child: Row(
            children: [
              // Icon asset image
              Image.asset(
                interactionType.assetPath,
                width: 30,
                height: 30,
                color: Colors.white,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to icon if asset fails
                  return Icon(
                    interactionType.fallbackIcon,
                    color: Colors.white,
                    size: 24,
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
                      interactionType.newTitle(context),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontFamily: AppFonts.graphie,
                        fontSize: 20,
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