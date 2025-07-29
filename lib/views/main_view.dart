import 'package:flutter/material.dart';

import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../core/constants/app_strings.dart';
import '../core/theme/venyu_theme.dart';
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
  final int _currentIndex = 0;
  
  final List<Widget> _pages = const [
    MatchesView(),
    NotificationsView(),
    ProfileView(),
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
            context.getThemedTabIconPath('match', false),
            width: 24,
            height: 24,
          ),
          activeIcon: Image.asset(
            context.getThemedTabIconPath('match', true),
            width: 24,
            height: 24,
          ),
          label: AppStrings.matches,
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            context.getThemedTabIconPath('notification', false),
            width: 24,
            height: 24,
          ),
          activeIcon: Image.asset(
            context.getThemedTabIconPath('notification', true),
            width: 24,
            height: 24,
          ),
          label: AppStrings.notifications,
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            context.getThemedTabIconPath('profile', false),
            width: 24,
            height: 24,
          ),
          activeIcon: Image.asset(
            context.getThemedTabIconPath('profile', true),
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