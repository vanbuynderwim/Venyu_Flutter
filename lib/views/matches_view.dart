import 'package:flutter/material.dart';

import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../core/constants/app_strings.dart';
import '../core/theme/app_theme.dart';
import '../models/match.dart';
import '../models/profile.dart';
import '../models/enums/match_status.dart';
import '../widgets/cards/match_item_view.dart';
import '../widgets/scaffolds/app_scaffold.dart';

/// MatchesView - Matches page with ListView for server data
class MatchesView extends StatelessWidget {
  const MatchesView({super.key});

  @override
  Widget build(BuildContext context) {
    // Create dummy Match objects with profiles
    final List<Match> dummyMatches = List.generate(
      10,
      (index) => Match(
        id: 'match_${index + 1}',
        profile: Profile(
          id: 'profile_${index + 1}',
          avatarID: index % 3 == 0 ? 'B0E4A5D7-8B3C-4F9A-A7E2-1234567890${index % 10}' : null,
          firstName: ['Emma', 'John', 'Sophie', 'Michael', 'Lisa', 'David', 'Maria', 'Tom', 'Sarah', 'Alex'][index],
          lastName: ['Johnson', 'Williams', 'Brown', 'Davis', 'Miller', 'Wilson', 'Garcia', 'Martinez', 'Anderson', 'Taylor'][index],
          contactEmail: 'contact${index + 1}@example.com',
          companyName: ['TechCorp', 'Design Studio', 'Marketing Agency', 'Consulting Group', 'Innovation Lab', 'Digital Solutions', 'Creative Works', 'Data Systems', 'Cloud Services', 'Mobile Apps'][index],
          bio: 'Senior ${['Developer', 'Designer', 'Manager', 'Consultant'][index % 4]} with ${5 + index} years of experience in ${['fintech', 'e-commerce', 'healthcare', 'education'][index % 4]}',
          isSuperAdmin: false,
          linkedInURL: 'https://linkedin.com/in/user${index + 1}',
          websiteURL: 'https://example${index + 1}.com',
          showEmail: index % 2 == 0,
          timestamp: DateTime.now().subtract(Duration(days: index)),
          registeredAt: DateTime.now().subtract(Duration(days: 30 + index)),
        ),
        status: index % 2 == 0 ? MatchStatus.matched : MatchStatus.connected,
        score: 0.85 + (index * 0.02),
        reason: 'Shared ${3 + index} common interests',
        updatedAt: DateTime.now().subtract(Duration(hours: index * 24)),
        unreadCount: index % 4 == 0 ? 3 : 0,
      ),
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
                      // Use custom match icon
                      context.themedIcon('match', size: 80),
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
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: MatchItemView(
                  match: match,
                  onMatchSelected: (selectedMatch) {
                    debugPrint('Tapped on match: ${selectedMatch.profile.fullName}');
                    // TODO: Navigate to match detail page
                  },
                ),
              );
            }).toList(),
    );
  }
}