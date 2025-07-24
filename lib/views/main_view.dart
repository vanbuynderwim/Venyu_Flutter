import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import '../core/constants/app_strings.dart';
import '../core/constants/app_assets.dart';
import 'matches_view.dart';
import 'notifications_view.dart';
import 'profile_view.dart';

/// MainView - Tab navigation using flutter_platform_widgets (based on Test project pattern)
class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _currentIndex = 0;
  
  final List<Widget> _pages = [
    const MatchesView(),
    const NotificationsView(),
    const ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return PlatformTabScaffold(
      tabController: PlatformTabController(
        initialIndex: _currentIndex,
      ),
      items: [
        BottomNavigationBarItem(
          icon: Image.asset(
            AppAssets.icons.match.regular,
            width: 24,
            height: 24,
          ),
          activeIcon: Image.asset(
            AppAssets.icons.match.selected,
            width: 24,
            height: 24,
          ),
          label: AppStrings.matches,
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            AppAssets.icons.notification.regular,
            width: 24,
            height: 24,
          ),
          activeIcon: Image.asset(
            AppAssets.icons.notification.selected,
            width: 24,
            height: 24,
          ),
          label: AppStrings.notifications,
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            AppAssets.icons.profile.regular,
            width: 24,
            height: 24,
          ),
          activeIcon: Image.asset(
            AppAssets.icons.profile.selected,
            width: 24,
            height: 24,
          ),
          label: AppStrings.profile,
        ),
      ],
      bodyBuilder: (context, index) => _pages[index],
    );
  }
}