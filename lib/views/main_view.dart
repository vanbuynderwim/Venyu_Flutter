import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../core/constants/app_strings.dart';
import '../core/constants/app_assets.dart';
import 'matches_view.dart';
import 'notifications_view.dart';
import 'profile_view.dart';

/// MainView - Platform-aware tab navigation with proper navigation structure
/// 
/// Each tab gets its own navigation stack with PlatformScaffold and proper AppBar
class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  late PlatformTabController _tabController;
  
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
  void initState() {
    super.initState();
    _tabController = PlatformTabController(initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformTabScaffold(
      tabController: _tabController,
      items: _tabs.map((tab) => BottomNavigationBarItem(
        icon: Image.asset(
          tab.iconPath.regular,
          width: 24,
          height: 24,
        ),
        activeIcon: Image.asset(
          tab.iconPath.selected,
          width: 24,
          height: 24,
        ),
        label: tab.label,
      )).toList(),
      bodyBuilder: (context, index) => _tabs[index].view,
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