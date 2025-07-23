import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/constants/app_strings.dart';
import '../core/constants/app_assets.dart';
import '../widgets/tab_view_scaffold.dart';

/// MatchesView - Clean implementation using TabViewScaffold
class MatchesView extends StatelessWidget {
  const MatchesView({super.key});

  @override
  Widget build(BuildContext context) {
    return TabViewScaffold(
      title: AppStrings.matches,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Use custom match icon from app_assets
            Image.asset(
              AppAssets.icons.match.regular,
              width: 80,
              height: 80,
            ),
            const SizedBox(height: 16),
            Text(
              'Your matches will appear here',
              style: AppTextStyles.subheadline,
            ),
            const SizedBox(height: 8),
            Text(
              'Start connecting with people to see matches',
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