import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/theme/app_fonts.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../../widgets/buttons/action_button.dart';
import '../../widgets/common/radar_background_overlay.dart';
import '../../widgets/common/progress_bar.dart';
import '../../models/enums/action_button_type.dart';
import '../../models/enums/registration_step.dart';
import '../profile/edit_name_view.dart';

/// Tutorial view that shows onboarding steps after registration
///
/// Shows 5 onboarding screens with images explaining how Venyu works:
/// 1. Cards - Create and publish your cards
/// 2. Match - Get matched with relevant people
/// 3. Interest - Express interest in matches
/// 4. Introduction - Get introduced to connections
/// 5. Done - Ready to start
class TutorialView extends StatefulWidget {
  const TutorialView({super.key});

  @override
  State<TutorialView> createState() => _TutorialViewState();
}

class _TutorialViewState extends State<TutorialView> {
  int _currentStep = 0;
  static const int _totalSteps = 5;

  // Tutorial content for each step
  final List<_TutorialStep> _steps = const [
    _TutorialStep(
      imagePath: 'assets/images/visuals/onboarding_cards.png',
      title: 'Answer 3 daily cards',
      description:
          'Each day, you answer three short cards from other entrepreneurs. It takes less than a minute and helps us find great matches for you.',
    ),
    _TutorialStep(
      imagePath: 'assets/images/visuals/onboarding_match.png',
      title: 'Get matched',
      description:
          'Our matching agent connects you with nearby entrepreneurs who share your goals and needs. Each match is meant to feel relevant and worthwhile.',
    ),
    _TutorialStep(
      imagePath: 'assets/images/visuals/onboarding_interest.png',
      title: 'Show your interest',
      description:
          'When someone catches your eye, say you\'re interested. It’s your way of telling us you’d like to be introduced to that person.',
    ),
    _TutorialStep(
      imagePath: 'assets/images/visuals/onboarding_introduction.png',
      title: 'Get introduced',
      description:
          'If there’s mutual interest, we’ll send an introduction email so you can start the conversation naturally.',
    ),
    _TutorialStep(
      imagePath: 'assets/images/visuals/onboarding_done.png',
      title: 'You got it!',
      description:
          'Now let’s set up your profile and join the community.',
    ),
  ];

  void _handleNext() {
    HapticFeedback.mediumImpact();

    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      // Last step - navigate to registration
      _navigateToRegistration();
    }
  }

  void _navigateToRegistration() {
    Navigator.of(context).push(
      platformPageRoute(
        context: context,
        builder: (context) => const EditNameView(
          registrationWizard: true,
          currentStep: RegistrationStep.name,
        ),
      ),
    );
  }

  void _handlePrevious() {
    HapticFeedback.lightImpact();

    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    final currentStepData = _steps[_currentStep];

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
          Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Column(
                children: [
                  // Scrollable content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          const SizedBox(height: 100),

                          // Image - fixed position in white circle with border
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
                                currentStepData.imagePath,
                                width: 80,
                                height: 80,
                                color: venyuTheme.darkText,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),

                          const SizedBox(height: 48),

                          // Title - fixed position
                          Text(
                            currentStepData.title,
                            style: TextStyle(
                              color: venyuTheme.darkText,
                              fontSize: 28,
                              fontFamily: AppFonts.graphie,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 16),

                          // Description
                          Text(
                            currentStepData.description,
                            style: AppTextStyles.body.copyWith(
                              color: venyuTheme.darkText,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),

                  // Progress bar and buttons - fixed at bottom
                  Column(
                    children: [
                      // Progress bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: ProgressBar(
                          pageNumber: _currentStep + 1,
                          numberOfPages: _totalSteps,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Navigation buttons
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          children: [
                            // Previous button (1/3 width) - only show if not on first step
                            if (_currentStep > 0) ...[
                              Expanded(
                                flex: 1,
                                child: ActionButton(
                                  label: 'Previous',
                                  onPressed: _handlePrevious,
                                  type: ActionButtonType.secondary,
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],

                            // Next button (2/3 width or full width if first step)
                            Expanded(
                              flex: _currentStep > 0 ? 2 : 1,
                              child: ActionButton(
                                label: 'Next',
                                onInvertedBackground: true,
                                onPressed: _handleNext,
                              ),
                            ),
                          ],
                        ),
                      ),

                      
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Data class for tutorial step content
class _TutorialStep {
  final String imagePath;
  final String title;
  final String description;

  const _TutorialStep({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}
