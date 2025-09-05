import 'package:flutter/material.dart';

import '../../core/theme/app_layout_styles.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/theme/venyu_theme.dart';
import '../../models/enums/onboarding_benefit.dart';

/// A reusable card widget that displays a list of onboarding benefits
/// with icons and descriptive text in a styled container.
class OnboardingBenefitsCard extends StatelessWidget {
  /// List of benefits to display
  final List<OnboardingBenefit> benefits;
  
  /// Optional padding around the card content
  final EdgeInsets? padding;

  const OnboardingBenefitsCard({
    super.key,
    required this.benefits,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final venyuTheme = context.venyuTheme;
    
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: AppLayoutStyles.cardDecoration(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: benefits.asMap().entries.map((entry) {
            final index = entry.key;
            final benefit = entry.value;
            
            return Column(
              children: [
                _buildBenefitRow(benefit, venyuTheme, context),
                // Add spacing between items except for the last one
                if (index < benefits.length - 1) const SizedBox(height: 24),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Builds a single benefit row with icon and text
  Widget _buildBenefitRow(OnboardingBenefit benefit, VenyuTheme venyuTheme, BuildContext context) {
    return Row(
      children: [
        // Icon - centered in container with primary color
        SizedBox(
          width: 24,
          height: 24,
          child: Center(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                venyuTheme.primary,
                BlendMode.srcIn,
              ),
              child: context.themedIcon(benefit.icon ?? 'help'),
            ),
          ),
        ),
        
        const SizedBox(width: 12),
        
        // Text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                benefit.title,
                style: AppTextStyles.body.copyWith(
                  color: venyuTheme.primaryText,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (benefit.description.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  benefit.description,
                  style: AppTextStyles.footnote.copyWith(
                    color: venyuTheme.secondaryText,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}