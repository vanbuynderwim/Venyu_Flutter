import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/theme/venyu_theme.dart';
import '../../models/enums/registration_step.dart';
import '../../services/session_manager.dart';
import '../../widgets/buttons/action_button.dart';
import '../../widgets/common/radar_background.dart';
import '../profile/edit_name_view.dart';

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
    final sessionManager = SessionManager.shared;
    final currentProfile = sessionManager.currentProfile;
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
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.primaryText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      
                      Text(
                        "Let's set up your professional profile.\nThis will only take a few minutes.",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: theme.secondaryText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Get Started button
                  ActionButton(
                    label: 'Get Started',
                    onPressed: () {
                      Navigator.of(context).push(
                        platformPageRoute(
                          context: context,
                          builder: (context) => const EditNameView(
                            registrationWizard: true,
                            currentStep: RegistrationStep.name,
                          ),
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