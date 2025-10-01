import 'package:app/core/theme/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../../widgets/buttons/action_button.dart';
import '../../models/enums/action_button_type.dart';
import 'login_view.dart';
import 'waitlist_view.dart';

/// Invite screening view - First screen for unauthenticated users
///
/// This view asks users whether they have an invite code, as Venyu is
/// an exclusive community for entrepreneurs by invitation only.
/// Features:
/// - Hero background image with opacity overlay
/// - Venyu logo at top
/// - Explanation text about exclusive community
/// - Two action buttons for invite code choice
/// - Navigation to login with choice parameter
class InviteScreeningView extends StatelessWidget {
  const InviteScreeningView({super.key});

  void _navigateToLogin(BuildContext context, bool hasInviteCode) {
    Navigator.push(
      context,
      platformPageRoute(
        context: context,
        builder: (context) => LoginView(hasInviteCode: hasInviteCode),
      ),
    );
  }

  void _navigateToWaitlist(BuildContext context) {
    Navigator.push(
      context,
      platformPageRoute(
        context: context,
        builder: (context) => const WaitlistView(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/visuals/hero.jpeg'),
            fit: BoxFit.cover,
            opacity: 0.6, // Apply opacity to background image
          ),
        ),
        child: Container(
          // Optional: Add a subtle gradient overlay for better text readability
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                venyuTheme.adaptiveBackground.withValues(alpha: 0.7),
                venyuTheme.adaptiveBackground.withValues(alpha: 0.9),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 60),

                  // Venyu Logo
                  Image.asset(
                    'assets/images/visuals/logo.png',
                    height: 140,
                    color: venyuTheme.gradientPrimary,
                    fit: BoxFit.contain,
                  ),

                  const Spacer(),

                  // Main content
                  Column(
                    children: [
                      Text(
                        'Welcome to venyu 🤝',
                        style: AppTextStyles.title1.copyWith(
                          color: venyuTheme.darkText,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFonts.graphie,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 8),

                      Text(
                         'The invite-only network for entrepreneurs. Real introductions. One minute a day.',
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w400,
                          color: venyuTheme.darkText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Action buttons
                  Column(
                    children: [
                      ActionButton(
                        label: 'I have an invite code',
                        type: ActionButtonType.primary,
                        onPressed: () => _navigateToLogin(context, true),
                      ),

                      const SizedBox(height: 8),

                      ActionButton(
                        label: "I don't have an invite code",
                        type: ActionButtonType.secondary,
                        onPressed: () => _navigateToWaitlist(context),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}