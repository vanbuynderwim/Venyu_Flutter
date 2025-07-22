import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/constants/app_strings.dart';
import '../core/constants/app_assets.dart';
import 'matches_view.dart';
import 'notifications_view.dart';
import 'profile_view.dart';

/// MainView - Main application interface with tab navigation
/// 
/// Provides the primary navigation structure for registered users
/// with tabs for Matches, Notifications, and Profile.
/// Uses custom icons from app_assets and separate view files.
class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _selectedIndex = 0;

  final List<_TabItem> _tabs = [
    _TabItem(
      iconPath: AppAssets.icons.match,
      label: AppStrings.matches,
      view: const MatchesView(),
    ),
    _TabItem(
      iconPath: AppAssets.icons.notification,
      label: AppStrings.notifications,
      view: const NotificationsView(),
    ),
    _TabItem(
      iconPath: AppAssets.icons.profile,
      label: AppStrings.profile,
      view: const ProfileView(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _tabs.map((tab) => tab.view).toList(),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: AppColors.secundair6Rocket,
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.background,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          selectedLabelStyle: AppTextStyles.caption1,
          unselectedLabelStyle: AppTextStyles.caption1,
          elevation: 0,
          items: _tabs.asMap().entries.map((entry) {
            final int index = entry.key;
            final _TabItem tab = entry.value;
            final bool isSelected = index == _selectedIndex;
            
            return BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(4),
                child: Image.asset(
                  isSelected ? tab.iconPath.selected : tab.iconPath.regular,
                  width: 24,
                  height: 24,
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                ),
              ),
              label: tab.label,
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _TabItem {
  final dynamic iconPath; // Will be _IconVariants from app_assets
  final String label;
  final Widget view;

  _TabItem({
    required this.iconPath,
    required this.label,
    required this.view,
  });
}