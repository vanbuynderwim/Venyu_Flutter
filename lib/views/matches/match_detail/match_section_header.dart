import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/venyu_theme.dart';

/// MatchSectionHeader - Reusable section header for match details
/// 
/// This widget displays a consistent section header with an icon and title
/// used throughout the match detail view for different sections like
/// cards, connections, tags, etc.
/// 
/// Features:
/// - Themed icon display
/// - Consistent typography
/// - Flexible icon and title content
class MatchSectionHeader extends StatelessWidget {
  final String iconName;
  final String title;

  const MatchSectionHeader({
    super.key,
    required this.iconName,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    
    return Row(
      children: [
        context.themedIcon(iconName, selected: true),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppTextStyles.subheadline.copyWith(
            color: venyuTheme.primaryText,
          ),
        ),
      ],
    );
  }
}