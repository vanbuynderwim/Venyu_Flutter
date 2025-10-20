import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../l10n/app_localizations.dart';
import '../../models/prompt.dart';
import '../../core/theme/app_fonts.dart';
import '../../core/theme/venyu_theme.dart';
import '../../widgets/buttons/action_button.dart';
import '../../widgets/common/radar_background_overlay.dart';
import '../../models/enums/action_button_type.dart';
import '../../core/providers/app_providers.dart';
import 'daily_prompts_view.dart';

/// Entry screen for prompt flow - shows before prompts when they exist
/// 
/// This view presents a welcome screen similar to InteractionTypeSelectionView
/// but specifically for the prompt flow. It has a single "Let's do this" button
/// that leads to the actual prompts.
class PromptEntryView extends StatelessWidget {
  final List<Prompt> prompts;
  final bool isModal;
  final bool isFirstTimeUser;
  final VoidCallback? onCloseModal;

  const PromptEntryView({
    super.key,
    required this.prompts,
    this.isModal = false,
    this.isFirstTimeUser = false,
    this.onCloseModal,
  });

  void _handleLetsDoThis(BuildContext context) {
    // Provide medium haptic feedback
    HapticFeedback.mediumImpact();

    Navigator.of(context).push(
      platformPageRoute(
        context: context,
        builder: (_) => DailyPromptsView(
          prompts: prompts,
          onCloseModal: onCloseModal,
          isFirstTimeUser: isFirstTimeUser,
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
      return ' $firstName';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Always use light theme for prompt flow
    final venyuTheme = context.venyuTheme;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            venyuTheme.gradientPrimary,
            Colors.white,
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
                padding: const EdgeInsets.all(36),
                child: Column(
              children: [
                const Spacer(flex: 1),
                
                // Greeting text
                Text(
                  l10n.promptEntryGreeting(_getFirstName(context)),
                  style: TextStyle(
                    color: venyuTheme.darkText,
                    fontSize: 28,
                    fontFamily: AppFonts.graphie
                  ),
                  textAlign: TextAlign.center,
                ),

                const Spacer(flex: 1),

                // Prompts icon in circle (like tutorial view)
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.6),
                    border: Border.all(
                      color: venyuTheme.darkText,
                      width: 5,
                    ),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/visuals/onboarding_cards.png',
                      width: 80,
                      height: 80,
                      color: venyuTheme.darkText,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback if icon fails to load
                        return Icon(
                          Icons.style_rounded,
                          size: 80,
                          color: venyuTheme.darkText,
                        );
                      },
                    ),
                  ),
                ),

                const Spacer(flex: 1),
                
                // Cards count text - different for first time users
                Text(
                  isFirstTimeUser
                    ? l10n.promptEntryFirstTimeDescription(prompts.length)
                    : l10n.promptEntryDailyDescription(prompts.length),
                  style: TextStyle(
                    color: venyuTheme.darkText,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 24),

                // "Show me!" button - wrapped in light theme
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ActionButton(
                      label: l10n.promptEntryButton,
                      type: ActionButtonType.primary,
                      onInvertedBackground: true,
                      onPressed: () => _handleLetsDoThis(context),
                    ),
                ),

                const SizedBox(height: 16),

                // "Not now" button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: ActionButton(
                      label: l10n.interactionTypeSelectionNotNowButton,
                      type: ActionButtonType.secondary,
                      onInvertedBackground: true,
                      onPressed: () {
                        if (onCloseModal != null) {
                          // Use the callback to close the modal
                          onCloseModal!();
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                ),

                const Spacer(flex: 1),
              ],
            ),
          ),
        ),
      ),
        ],
      ),
    );
  }
}