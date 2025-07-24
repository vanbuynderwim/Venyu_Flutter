import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../core/constants/app_strings.dart';
import '../core/constants/app_assets.dart';
import '../services/index.dart';
import 'showcase_view.dart';
import 'profile_edit_view.dart';

/// ProfileView - Profile page with platform-aware scaffold
class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(AppStrings.profile),
        trailingActions: [
          PlatformIconButton(
            padding: EdgeInsets.zero,
            icon: Icon(Icons.palette),
            onPressed: () {
              Navigator.of(context).push(
                platformPageRoute(
                  context: context,
                  builder: (context) => const ShowcaseView(),
                ),
              );
            },
          ),
          PlatformIconButton(
            padding: EdgeInsets.zero,
            icon: Image.asset(
              AppAssets.icons.settings.regular,
              width: 24,
              height: 24,
            ),
            onPressed: () {
              Navigator.of(context).push(
                platformPageRoute(
                  context: context,
                  builder: (context) => const ProfileEditView(),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Consumer<SessionManager>(
          builder: (context, sessionManager, _) {
            final profile = sessionManager.currentProfile;
            final user = sessionManager.currentUser;
            
            return ListView(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                      const SizedBox(height: 20),
                      
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
                      const SizedBox(height: 32),
                      
                      // Sign Out Button
                      PlatformElevatedButton(
                        onPressed: () async {
                          try {
                            await sessionManager.signOut();
                          } catch (error) {
                            debugPrint('Sign out error: $error');
                          }
                        },
                        color: AppColors.error,
                        child: Text(
                          'Sign Out',
                          style: AppTextStyles.callout.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

