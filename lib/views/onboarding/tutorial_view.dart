import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../l10n/app_localizations.dart';
import '../../core/theme/app_fonts.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../../widgets/buttons/action_button.dart';
import '../../widgets/common/radar_background_overlay.dart';
import '../../widgets/common/progress_bar.dart';
import '../../models/enums/action_button_type.dart';
import '../profile/edit_optin_view.dart';
import 'tutorial_done_view.dart';

/// Tutorial view that shows onboarding steps after registration
///
/// Shows 5 onboarding screens with images explaining how Venyu works:
/// 1. Offer - Create prompts about what you offer
/// 2. Answer - Answer prompts from others you can help with
/// 3. Match - Get matched when you can help
/// 4. Introduction - The searcher decides to introduce
/// 5. Search - Create your own search prompt
class TutorialView extends StatefulWidget {
  /// Whether this is a returning user seeing the tutorial again after an update
  final bool isReturningUser;

  /// Callback to close the modal when tutorial is complete (for returning users)
  final VoidCallback? onCloseModal;

  const TutorialView({
    super.key,
    this.isReturningUser = false,
    this.onCloseModal,
  });

  @override
  State<TutorialView> createState() => _TutorialViewState();
}

class _TutorialViewState extends State<TutorialView> {
  int _currentStep = 0;
  static const int _totalSteps = 6;

  // Tutorial content for each step - images are static
  final List<String> _stepImages = const [
    'assets/images/visuals/onboarding_logo.png',
    'assets/images/visuals/onboarding_prompt.png',
    'assets/images/visuals/onboarding_cards.png',
    'assets/images/visuals/onboarding_match.png',
    'assets/images/visuals/onboarding_introduction.png',
    'assets/images/visuals/onboarding_search.png',
  ];

  void _handleNext() {
    HapticFeedback.mediumImpact();

    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      // Last step - navigate to done view
      _navigateToDoneView();
    }
  }

  void _navigateToDoneView() {
    if (widget.isReturningUser) {
      // For returning users, show opt-in screen first
      Navigator.of(context).push(
        platformPageRoute(
          context: context,
          builder: (context) => EditOptinView(
            registrationWizard: false,
            isReturningUser: true,
            onCloseModal: widget.onCloseModal,
          ),
        ),
      );
    } else {
      // For new users, go directly to done view
      Navigator.of(context).push(
        platformPageRoute(
          context: context,
          builder: (context) => TutorialDoneView(
            isReturningUser: widget.isReturningUser,
            onCloseModal: widget.onCloseModal,
          ),
        ),
      );
    }
  }

  void _handlePrevious() {
    HapticFeedback.lightImpact();

    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  // Helper to get step content based on current index
  String _getStepTitle(BuildContext context, int index) {
    final l10n = AppLocalizations.of(context)!;
    switch (index) {
      case 0: return l10n.tutorialStep0Title;
      case 1: return l10n.tutorialStep1Title;
      case 2: return l10n.tutorialStep2Title;
      case 3: return l10n.tutorialStep3Title;
      case 4: return l10n.tutorialStep4Title;
      case 5: return l10n.tutorialStep5Title;
      default: return '';
    }
  }

  String _getStepDescription(BuildContext context, int index) {
    final l10n = AppLocalizations.of(context)!;
    switch (index) {
      case 0: return l10n.tutorialStep0Description;
      case 1: return l10n.tutorialStep1Description;
      case 2: return l10n.tutorialStep2Description;
      case 3: return l10n.tutorialStep3Description;
      case 4: return l10n.tutorialStep4Description;
      case 5: return l10n.tutorialStep5Description;
      default: return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    final l10n = AppLocalizations.of(context)!;

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
                                _stepImages[_currentStep],
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
                            _getStepTitle(context, _currentStep),
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
                            _getStepDescription(context, _currentStep),
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
                        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 8),
                        child: Row(
                          children: [
                            // Previous button (1/3 width) - only show if not on first step
                            if (_currentStep > 0) ...[
                              Expanded(
                                flex: 1,
                                child: ActionButton(
                                  label: l10n.tutorialButtonPrevious,
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
                                label: l10n.tutorialButtonNext,
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
