import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_modifiers.dart';

/// A horizontal progress indicator showing completion status across multiple steps.
/// 
/// This widget displays a series of progress segments, with completed steps
/// highlighted in the accent color and remaining steps in a muted color.
/// Commonly used in multi-step forms, onboarding flows, and wizards.
/// 
/// The progress bar automatically:
/// - Calculates completion based on current page vs total pages
/// - Applies theme-aware colors
/// - Provides visual feedback for user progress
/// 
/// Example usage:
/// ```dart
/// // Show progress in a 5-step wizard, currently on step 3
/// ProgressBar(
///   pageNumber: 3,
///   numberOfPages: 5,
/// )
/// ```
class ProgressBar extends StatelessWidget {
  /// The current step/page number (1-based).
  final int pageNumber;
  
  /// The total number of steps/pages in the process.
  final int numberOfPages;

  /// Creates a [ProgressBar] widget.
  /// 
  /// [pageNumber] should be 1-based and <= [numberOfPages].
  /// [numberOfPages] must be greater than 0.
  const ProgressBar({
    super.key,
    required this.pageNumber,
    required this.numberOfPages,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Row(
        children: List.generate(numberOfPages, (index) {
          final stepNumber = index + 1;
          final isActive = stepNumber <= pageNumber;
          
          return Expanded(
            child: Container(
              height: 6,
              margin: EdgeInsets.only(
                right: 6
              ),
              decoration: BoxDecoration(
                color: isActive 
                    ? AppColors.accent1Tangerine 
                    : AppColors.secundair6Rocket,
                borderRadius: BorderRadius.circular(AppModifiers.defaultRadius),
              ),
            ),
          );
        }),
      ),
    );
  }
}