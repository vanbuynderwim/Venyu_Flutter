import 'package:flutter/material.dart';

import '../../core/theme/venyu_theme.dart';
import '../../core/theme/app_text_styles.dart';
import '../../services/supabase_manager.dart';
import '../../services/toast_service.dart';
import '../../widgets/common/radar_background.dart';

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
      final supabaseManager = SupabaseManager.shared;
      await supabaseManager.completeRegistration();
      
      // Registration completed successfully
      // The SessionManager will handle navigation to main app via auth state changes
      debugPrint('✅ Registration completed successfully');
    } catch (error) {
      debugPrint('❌ Failed to complete registration: $error');
      
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
                        'Congratulations! 🎉',
                        style: AppTextStyles.title2.copyWith(
                          color: venyuTheme.primaryText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      Text(
                        'Your profile is complete!',
                        style: AppTextStyles.headline.copyWith(
                          color: venyuTheme.primaryText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 30),
                      
                      Text(
                        'Thank you for taking the time to create your professional profile. You\'re all set to connect with like-minded professionals and unlock new opportunities.',
                        style: AppTextStyles.subheadline.copyWith(
                          color: venyuTheme.secondaryText,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 60),
                  
                  // Enter Venyu button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isCompleting ? null : _completeRegistration,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: venyuTheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: _isCompleting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              'Enter Venyu',
                              style: AppTextStyles.headline.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
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