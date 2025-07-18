import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// ProgressBar - Flutter equivalent van Swift ProgressBar
class ProgressBar extends StatelessWidget {
  final int pageNumber;
  final int numberOfPages;

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
              height: 4,
              margin: EdgeInsets.only(
                right: 5,
              ),
              decoration: BoxDecoration(
                color: isActive 
                    ? AppColors.accent1Tangerine 
                    : AppColors.secundair6Rocket,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }
}