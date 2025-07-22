import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../core/constants/app_strings.dart';
import '../core/constants/app_assets.dart';
import '../services/index.dart';
import 'showcase_view.dart';

/// ProfileView - Dedicated view for profile tab
/// 
/// Displays user profile information and profile management options.
/// This replaces the inline _ProfileView from main_view.dart.
class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.profile, style: AppTextStyles.headline),
        actions: [
          IconButton(
            icon: const Icon(Icons.palette),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ShowcaseView()),
              );
            },
          ),
          IconButton(
            icon: Image.asset(
              AppAssets.icons.settings.regular,
              width: 24,
              height: 24,
            ),
            onPressed: () {
              // TODO: Navigate to settings
              debugPrint('Navigate to settings');
            },
          ),
        ],
      ),
      body: Consumer<SessionManager>(
        builder: (context, sessionManager, _) {
          final profile = sessionManager.currentProfile;
          final user = sessionManager.currentUser;
          
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Profile Avatar
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    AppAssets.icons.profile.regular,
                    width: 60,
                    height: 60,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Profile Name
                Text(
                  profile?.displayName ?? user?.email ?? 'Your Profile',
                  style: AppTextStyles.title2,
                ),
                const SizedBox(height: 8),
                
                // Profile Email
                if (profile?.contactEmail != null || user?.email != null)
                  Text(
                    profile?.contactEmail ?? user?.email ?? '',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                const SizedBox(height: 16),
                
                // Sign Out Button
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await sessionManager.signOut();
                    } catch (error) {
                      debugPrint('Sign out error: $error');
                      // Error is already handled by SessionManager
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    'Sign Out',
                    style: AppTextStyles.callout.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}