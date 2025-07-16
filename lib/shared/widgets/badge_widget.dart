import 'package:flutter/material.dart';
import '../../core/themes/app_colors.dart';

class BadgeWidget extends StatelessWidget {
  final int count;
  final Widget child;
  final bool showBadge;

  const BadgeWidget({
    super.key,
    required this.count,
    required this.child,
    this.showBadge = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!showBadge || count <= 0) {
      return child;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          right: -6,
          top: -6,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: AppColors.badgeBackground,
              shape: BoxShape.circle,
            ),
            constraints: const BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            child: Center(
              child: Text(
                count > 99 ? '99+' : count.toString(),
                style: const TextStyle(
                  color: AppColors.badgeText,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }
}