import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/theme/venyu_theme.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/utils/app_logger.dart';
import '../../services/session_manager.dart';
import '../../services/supabase_managers/profile_manager.dart';
import '../../services/toast_service.dart';
import '../../widgets/buttons/action_button.dart';
import '../../widgets/common/radar_background.dart';
import '../main_view.dart';

/// Final view in the registration wizard that completes the user's profile
/// 
/// This view congratulates the user on completing their profile and provides
/// an "Enter Venyu" button that calls completeRegistration() and transitions
/// to the main app experience.
class RegistrationCompleteView extends StatefulWidget {
  const RegistrationCompleteView({super.key});

  @override
  State<RegistrationCompleteView> createState() => _RegistrationCompleteViewState();
}

class _RegistrationCompleteViewState extends State<RegistrationCompleteView> {
  bool _isCompleting = false;

  Future<void> _completeRegistration() async {
    if (_isCompleting) return;

    setState(() {
      _isCompleting = true;
    });

    try {
      final profileManager = ProfileManager.shared;
      await profileManager.completeRegistration();
      
      // Refresh the user profile so SessionManager knows registration is complete
      final sessionManager = SessionManager.shared;
      await sessionManager.refreshProfile();
      
      AppLogger.success('Registration completed successfully', context: 'RegistrationCompleteView');
      AppLogger.info('Current auth state: ${sessionManager.authState}', context: 'RegistrationCompleteView');
      AppLogger.info('Profile registered at: ${sessionManager.currentProfile?.registeredAt}', context: 'RegistrationCompleteView');
      
      // Navigate to main app - registration is complete
      if (mounted) {
        // Use pushAndRemoveUntil to clear the entire navigation stack
        Navigator.of(context).pushAndRemoveUntil(
          platformPageRoute(
            context: context,
            builder: (context) => const MainView(),
          ),
          (route) => false, // Remove all previous routes
        );
      }
    } catch (error) {
      AppLogger.error('Failed to complete registration', error: error, context: 'RegistrationCompleteView');
      
      if (mounted) {
        ToastService.error(
          context: context,
          message: 'Failed to complete registration. Please try again.',
        );
      }
      
      // Error tracking handled within SupabaseManager methods
    } finally {
      if (mounted) {
        setState(() {
          _isCompleting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    
    return Scaffold(
      body: Stack(
        children: [
          // Full-screen radar background image
          const RadarBackground(),
          
          // Content overlay
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const Spacer(),
                  
                  // Main content
                  Column(
                    children: [
                      Text(
                        'Your profile is complete! 🎉',
                        style: AppTextStyles.title2.copyWith(
                          color: venyuTheme.primaryText,
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      Text(
                        'Thank you for taking the time to create your professional profile. You\'re all set to connect with like-minded professionals and unlock new opportunities.',
                        style: AppTextStyles.subheadline.copyWith(
                          color: venyuTheme.secondaryText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Enter Venyu button
                  ActionButton(
                    label: 'Enter Venyu',
                    onPressed: _completeRegistration,
                    isLoading: _isCompleting,
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