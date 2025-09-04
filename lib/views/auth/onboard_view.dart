import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/theme/venyu_theme.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/providers/app_providers.dart';
import '../../widgets/buttons/action_button.dart';
import '../../widgets/common/radar_background.dart';
import '../subscription/paywall_view.dart';

/// OnboardView - Registration start screen matching iOS RegisterStartView
/// 
/// Welcome screen for new users after authentication, before profile setup.
/// Features full-screen radar background and welcome message with user's name.
class OnboardView extends StatefulWidget {
  const OnboardView({super.key});

  @override
  State<OnboardView> createState() => _OnboardViewState();
}

class _OnboardViewState extends State<OnboardView> {
  @override
  Widget build(BuildContext context) {
    final theme = context.venyuTheme;
    final profileService = context.profileService;
    final currentProfile = profileService.currentProfile;
    final firstName = currentProfile?.firstName ?? 'there';

    return Scaffold(
      body: Stack(
        children: [
          // Full-screen radar background image
          const RadarBackground(),
          
          // Content overlay
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const Spacer(),
                  
                  // Welcome text section
                  Column(
                    children: [
                      Text(
                        'Welcome $firstName 👋',
                        style: AppTextStyles.title2.copyWith(
                          color: theme.primaryText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      
                      Text(
                        "Let's set up your professional profile.\nThis will only take a few minutes.",
                        style: AppTextStyles.callout.copyWith(
                          color: theme.secondaryText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Get Started button - TEMPORARILY show PaywallView first
                  ActionButton(
                    label: 'Get Started',
                    onPressed: () {
                      Navigator.of(context).push(
                        platformPageRoute(
                          context: context,
                          builder: (context) => const PaywallView(), // TEMPORARY: Show paywall first for testing
                        ),
                      );
                    },
                  ),
                  
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}