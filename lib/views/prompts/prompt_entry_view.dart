import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../models/prompt.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';
import '../../core/theme/venyu_theme.dart';
import '../../widgets/buttons/action_button.dart';
import '../../models/enums/action_button_type.dart';
import '../../services/session_manager.dart';
import 'prompts_view.dart';

/// Entry screen for prompt flow - shows before prompts when they exist
/// 
/// This view presents a welcome screen similar to InteractionTypeSelectionView
/// but specifically for the prompt flow. It has a single "Let's do this" button
/// that leads to the actual prompts.
class PromptEntryView extends StatelessWidget {
  final List<Prompt> prompts;

  const PromptEntryView({
    super.key,
    required this.prompts,
  });

  void _handleLetsDoThis(BuildContext context) {
    // Provide medium haptic feedback
    HapticFeedback.mediumImpact();
    
    // Navigate to PromptsView
    Navigator.of(context).push(
      platformPageRoute(
        context: context,
        builder: (context) => PromptsView(prompts: prompts),
      ),
    );
  }

  /// Get greeting based on time of day
  String _getTimeBasedGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'Good morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good afternoon';
    } else if (hour >= 17 && hour < 22) {
      return 'Good evening';
    } else {
      return 'Good night';
    }
  }

  /// Get user's first name from session
  String _getFirstName() {
    final sessionManager = SessionManager.shared;
    final profile = sessionManager.currentProfile;
    final firstName = profile?.firstName;
    if (firstName != null && firstName.isNotEmpty) {
      return '\n $firstName';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final venyuTheme = context.venyuTheme;
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primair4Lilac,
            isDark ? AppColors.secundair3Slategray : Colors.white,
          ],
        ),
      ),
      child: PlatformScaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(flex: 1),
                
                // Greeting text
                Text(
                  '👋  ${_getTimeBasedGreeting()},${_getFirstName()}',
                  style: TextStyle(
                    color: venyuTheme.primaryText,
                    fontSize: 32,
                    fontFamily: AppFonts.graphie
                  ),
                  textAlign: TextAlign.center,
                ),
              
                const Spacer(flex: 1),
                
                // Cards count text
                Text(
                  'We have selected ${prompts.length} new cards for you.',
                  style: TextStyle(
                    color: venyuTheme.primaryText,
                    fontSize: 18,
                    fontFamily: AppFonts.graphie
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 24),
                
                // "Let's do this" button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ActionButton(
                    label: "Make the net work",
                    type: ActionButtonType.primary,
                    onPressed: () => _handleLetsDoThis(context),
                  ),
                ),

                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}