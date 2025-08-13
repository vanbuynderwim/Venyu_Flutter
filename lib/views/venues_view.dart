import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../core/constants/app_strings.dart';
import '../core/theme/app_text_styles.dart';
import '../core/theme/venyu_theme.dart';
import '../widgets/scaffolds/app_scaffold.dart';

/// VenuesView - Dedicated view for venues
/// 
/// This view displays venues that the user has visited or interacted with.
/// Previously this content was part of the ProfileView's venues section.
/// Currently shows a "Coming soon" placeholder until venues functionality is implemented.
/// 
/// Features:
/// - Placeholder for venues functionality
/// - Consistent styling with other views
/// - Ready for venues implementation
class VenuesView extends StatefulWidget {
  const VenuesView({super.key});

  @override
  State<VenuesView> createState() => _VenuesViewState();
}

class _VenuesViewState extends State<VenuesView> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: PlatformAppBar(
        title: Text(AppStrings.venues),
      ),
      useSafeArea: true,
      body: _buildVenuesContent(),
    );
  }

  /// Builds the venues content - currently a placeholder
  Widget _buildVenuesContent() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.place_outlined,
              size: 64,
              color: context.venyuTheme.secondaryText,
            ),
            const SizedBox(height: 16),
            Text(
              'Venues',
              style: AppTextStyles.headline.copyWith(
                color: context.venyuTheme.primaryText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Coming soon',
              style: AppTextStyles.body.copyWith(
                color: context.venyuTheme.secondaryText,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}