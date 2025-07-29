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
          icon: context.themedIcon('match', selected: false),
          activeIcon: context.themedIcon('match', selected: true),
          label: AppStrings.matches,
        ),
        BottomNavigationBarItem(
          icon: context.themedIcon('notification', selected: false),
          activeIcon: context.themedIcon('notification', selected: true),
          label: AppStrings.notifications,
        ),
        BottomNavigationBarItem(
          icon: context.themedIcon('profile', selected: false),
          activeIcon: context.themedIcon('profile', selected: true),
          label: AppStrings.profile,
        ),
      ],
      bodyBuilder: (context, index) => _pages[index],
    );
  }
}