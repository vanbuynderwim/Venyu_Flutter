import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../models/prompt.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';
import '../../core/theme/venyu_theme.dart';
import '../../widgets/buttons/action_button.dart';
import '../../models/enums/action_button_type.dart';
import '../../core/providers/app_providers.dart';
import 'prompts_view.dart';

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
        builder: (_) => PromptsView(
          prompts: prompts,
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
      return ' $firstName';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    // Always use light theme for prompt flow
    final venyuTheme = VenyuTheme.light;
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primair4Lilac,
            Colors.white,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Radar background image
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
                
                // Greeting text
                Text(
                  'Hi${_getFirstName(context)} 👋',
                  style: TextStyle(
                    color: venyuTheme.primaryText,
                    fontSize: 28,
                    fontFamily: AppFonts.graphie
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const Spacer(flex: 1),
                
                // Prompts icon
                Image.asset(
                  'assets/images/visuals/prompts.png',
                  width: 134,
                  height: 134,
                  color: venyuTheme.primaryText,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback if icon fails to load
                    return Icon(
                      Icons.style_rounded,
                      size: 80,
                      color: venyuTheme.primaryText,
                    );
                  },
                ),
              
                const Spacer(flex: 1),
                
                // Cards count text - different for first time users
                Text(
                  isFirstTimeUser 
                    ? "Let's start networking!\nAnswer ${prompts.length} questions to get matched"
                    : 'Your daily ${prompts.length} cards are here !',
                  style: TextStyle(
                    color: venyuTheme.primaryText,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 24),
                
                // "Show me!" button - wrapped in light theme
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Theme(
                    data: ThemeData.light().copyWith(
                      extensions: [VenyuTheme.light],
                    ),
                    child: ActionButton(
                      label: "Show me",
                      type: ActionButtonType.primary,
                      onPressed: () => _handleLetsDoThis(context),
                    ),
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