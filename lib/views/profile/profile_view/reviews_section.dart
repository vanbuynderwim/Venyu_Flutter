import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../../models/badge_data.dart';
import '../../../models/enums/review_type.dart';
import '../../../widgets/buttons/option_button.dart';
import '../review_pending_prompts_view.dart';

/// ReviewsSection - Admin reviews section
///
/// This widget displays the reviews section for super admin users.
/// It shows options for both user-generated and AI-generated card reviews.
///
/// Features:
/// - User-generated reviews option with badge count
/// - AI/System-generated reviews option with badge count
/// - Navigation to review pending cards view
/// - Admin-only visibility
class ReviewsSection extends StatelessWidget {
  final BadgeData? badgeData;

  const ReviewsSection({
    super.key,
    this.badgeData,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [];
    
    // User generated reviews
    children.add(
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: OptionButton(
          option: ReviewType.user,
          isSelected: false,
          isMultiSelect: false,
          isSelectable: false,
          isCheckmarkVisible: false,
          isChevronVisible: true,
          isButton: true,
          withDescription: true,
          badgeCount: badgeData?.userReviewsCount ?? 0,
          onSelect: () {
            Navigator.push(
              context,
              platformPageRoute(
                context: context,
                builder: (context) => const ReviewPendingPromptsView(
                  reviewType: ReviewType.user,
                ),
              ),
            );
          },
        ),
      ),
    );

    // AI generated reviews
    children.add(
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 0),
        child: OptionButton(
          option: ReviewType.system,
          isSelected: false,
          isMultiSelect: false,
          isSelectable: false,
          isCheckmarkVisible: false,
          isChevronVisible: true,
          isButton: true,
          withDescription: true,
          badgeCount: badgeData?.systemReviewsCount ?? 0,
          onSelect: () {
            Navigator.push(
              context,
              platformPageRoute(
                context: context,
                builder: (context) => const ReviewPendingPromptsView(
                  reviewType: ReviewType.system,
                ),
              ),
            );
          },
        ),
      ),
    );
    
    return Column(children: children);
  }
}