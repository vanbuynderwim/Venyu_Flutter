import 'package:flutter/material.dart';
import 'dart:io';
import '../../core/constants/app_icons.dart';
import '../../core/themes/app_colors.dart';
import 'app_icon_widget.dart';
import 'badge_widget.dart';

class CustomTabBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final int matchesBadgeCount;
  final int notificationsBadgeCount;
  final int profileBadgeCount;

  const CustomTabBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.matchesBadgeCount,
    required this.notificationsBadgeCount,
    required this.profileBadgeCount,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return _buildIOSTabBar();
    } else {
      return _buildAndroidTabBar();
    }
  }

  Widget _buildIOSTabBar() {
    return Container(
      height: 83,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(
            color: AppColors.grey200.withValues(alpha: 0.3),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            _buildTabItem(0, 'Venyu', AppIcons.homeRegular, AppIcons.homeSelected, 0),
            _buildTabItem(1, 'Matches', AppIcons.coupleRegular, AppIcons.coupleSelected, matchesBadgeCount),
            _buildTabItem(2, 'Notifications', AppIcons.notificationRegular, AppIcons.notificationSelected, notificationsBadgeCount),
            _buildTabItem(3, 'Profile', AppIcons.profileRegular, AppIcons.profileSelected, profileBadgeCount),
          ],
        ),
      ),
    );
  }

  Widget _buildAndroidTabBar() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            _buildTabItem(0, 'Venyu', AppIcons.homeRegular, AppIcons.homeSelected, 0),
            _buildTabItem(1, 'Matches', AppIcons.coupleRegular, AppIcons.coupleSelected, matchesBadgeCount),
            _buildTabItem(2, 'Notifications', AppIcons.notificationRegular, AppIcons.notificationSelected, notificationsBadgeCount),
            _buildTabItem(3, 'Profile', AppIcons.profileRegular, AppIcons.profileSelected, profileBadgeCount),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(int index, String label, String regularIcon, String selectedIcon, int badgeCount) {
    final isSelected = currentIndex == index;
    final iconSize = Platform.isIOS ? 24.0 : 24.0;
    final fontSize = Platform.isIOS ? 10.0 : 12.0;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: SizedBox(
                  height: iconSize + 2,
                  child: BadgeWidget(
                    count: badgeCount,
                    showBadge: badgeCount > 0,
                    child: AppIconWidget(
                      iconPath: isSelected ? selectedIcon : regularIcon,
                      width: iconSize,
                      height: iconSize,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: Platform.isIOS ? FontWeight.w500 : FontWeight.w400,
                    color: isSelected ? AppColors.tabBarSelected : AppColors.tabBarUnselected,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}