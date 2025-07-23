import 'package:app/core/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'dart:io' show Platform;
import '../core/theme/app_theme.dart';
import '../core/constants/app_strings.dart';
import '../core/constants/app_assets.dart';
import '../services/index.dart';
import 'showcase_view.dart';

/// ProfileView - Dedicated view for profile tab
/// 
/// Displays user profile information and profile management options.
class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Large Title AppBar
          SliverAppBar(
            expandedHeight: Platform.isIOS ? 100.0 : 80.0,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.background,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                AppStrings.profile,
                style: Platform.isIOS ? AppTextStyles.largeTitle : AppTextStyles.title1,
              ),
              // BELANGRIJK: centerTitle op false voor iOS large title effect
              centerTitle: !Platform.isIOS,
              titlePadding: EdgeInsets.only(
                left: 16, // Altijd 16 voor consistente left alignment
                bottom: Platform.isIOS ? 14 : 16,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Platform.isIOS ? CupertinoIcons.paintbrush : Icons.palette,
                  color: AppColors.textPrimary,
                ),
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
          
          // Profile Content
          SliverToBoxAdapter(
            child: Consumer<SessionManager>(
              builder: (context, sessionManager, _) {
                final profile = sessionManager.currentProfile;
                final user = sessionManager.currentUser;
                
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      
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
                      const SizedBox(height: 32),
                      
                      // Sign Out Button
                      ElevatedButton(
                        onPressed: () async {
                          try {
                            await sessionManager.signOut();
                          } catch (error) {
                            debugPrint('Sign out error: $error');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(200, 48),
                        ),
                        child: Text(
                          'Sign Out',
                          style: AppTextStyles.callout.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      
                      // Extra content om scroll te demonstreren
                      const SizedBox(height: 40),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}