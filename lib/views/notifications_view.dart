import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/constants/app_strings.dart';
import '../core/constants/app_assets.dart';

/// NotificationsView - Dedicated view for notifications tab
/// 
/// Displays user notifications and notification management.
/// This replaces the inline _NotificationsView from main_view.dart.
class NotificationsView extends StatelessWidget {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.notifications, style: AppTextStyles.headline),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Use custom notification icon from app_assets
            Image.asset(
              AppAssets.icons.notification.regular,
              width: 80,
              height: 80,
            ),
            const SizedBox(height: 16),
            Text(
              'No new notifications',
              style: AppTextStyles.subheadline,
            ),
            const SizedBox(height: 8),
            Text(
              'We\'ll notify you when there\'s something new',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}