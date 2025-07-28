import 'package:flutter/material.dart';

import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../core/constants/app_strings.dart';
import '../core/theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/index.dart';

/// OnboardView - First-time user onboarding screen
/// 
/// Guides new users through the initial setup process
/// after successful authentication.
class OnboardView extends StatefulWidget {
  const OnboardView({super.key});

  @override
  State<OnboardView> createState() => _OnboardViewState();
}

class _OnboardViewState extends State<OnboardView> {
  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    
    return AppScaffold(
      appBar: PlatformAppBar(
        title: Text(
          'Welcome to ${AppStrings.appName}',
          style: AppTextStyles.headline,
        ),
        material: (_, __) => MaterialAppBarData(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        cupertino: (_, __) => CupertinoNavigationBarData(
          backgroundColor: Colors.transparent,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          
          // Welcome message
          Text(
            'Let\'s get you started',
            style: AppTextStyles.largeTitle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          
          Text(
            'We\'ll help you set up your profile and preferences to make the most of your networking experience.',
            style: AppTextStyles.body.copyWith(
              color: venyuTheme.secondaryText,
            ),
            textAlign: TextAlign.center,
          ),
          
          const Spacer(),
          
          // Onboarding illustration placeholder
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: venyuTheme.cardBackground,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.rocket_launch,
                size: 80,
                color: venyuTheme.primary,
              ),
            ),
          ),
          
          const Spacer(),
          
          // Action buttons
          ActionButton(
            label: 'Set up profile',
            style: ActionButtonType.primary,
            onPressed: () {
              // TODO: Navigate to profile setup
              debugPrint('Navigate to profile setup');
            },
          ),
          const SizedBox(height: 12),
          
          ActionButton(
            label: 'Skip for now',
            style: ActionButtonType.secondary,
            onPressed: () {
              // TODO: Skip to main view
              debugPrint('Skip onboarding');
            },
          ),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}