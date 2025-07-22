import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/constants/app_strings.dart';
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Welcome to ${AppStrings.appName}',
          style: AppTextStyles.headline,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
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
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              
              const Spacer(),
              
              // Onboarding illustration placeholder
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.primair7Pearl,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.rocket_launch,
                    size: 80,
                    color: AppColors.primary,
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
        ),
      ),
    );
  }
}