import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../core/theme/app_theme.dart';
import '../core/constants/app_strings.dart';
import '../core/constants/app_assets.dart';
import '../widgets/scaffolds/app_scaffold.dart';

/// MatchesView - Matches page with ListView for server data
class MatchesView extends StatelessWidget {
  const MatchesView({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with actual matches data from server
    final List<Map<String, String>> dummyMatches = List.generate(
      20,
      (index) => {
        'name': 'Match ${index + 1}',
        'company': 'Company ${index + 1}',
        'status': index % 3 == 0 ? 'New' : 'Active',
      },
    );

    return AppListScaffold(
      appBar: PlatformAppBar(
        title: Text(AppStrings.matches),
      ),
      children: dummyMatches.isEmpty
          ? [
              // Empty state als single child in ListView
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Center(
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
              ),
            ]
          : dummyMatches.map((match) {
              return PlatformListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primaryLight,
                  child: Text(
                    match['name']![0],
                    style: AppTextStyles.callout.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(match['name']!),
                subtitle: Text(match['company']!),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: match['status'] == 'New' ? AppColors.primary : AppColors.textSecondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    match['status']!,
                    style: AppTextStyles.caption1.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                onTap: () {
                  debugPrint('Tapped on match: ${match['name']}');
                  // TODO: Navigate to match detail page
                },
              );
            }).toList(),
    );
  }
}