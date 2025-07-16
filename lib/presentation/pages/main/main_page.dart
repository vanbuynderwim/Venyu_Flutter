import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/themes/app_colors.dart';
import '../../../shared/widgets/app_icon_widget.dart';
import '../../../shared/widgets/badge_widget.dart';
import '../feed/feed_page.dart';
import '../matches/matches_page.dart';
import '../notifications/notifications_page.dart';
import '../profile/profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  
  // TODO: Deze waardes komen later uit een state management systeem
  int matchesBadgeCount = 3;
  int notificationsBadgeCount = 5;
  int profileBadgeCount = 1;

  final List<Widget> _pages = [
    const FeedPage(),
    const MatchesPage(),
    const NotificationsPage(),
    const ProfilePage(),
  ];

  void _onTabTapped(int index) {
    if (index != _currentIndex) {
      // Haptic feedback bij tab switch
      HapticFeedback.selectionClick();
      
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.tabBarSelected,
        unselectedItemColor: AppColors.tabBarUnselected,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        iconSize: 24,
        items: [
          // Feed Tab
          BottomNavigationBarItem(
            icon: AppIconWidget(
              iconPath: _currentIndex == 0 ? AppIcons.homeSelected : AppIcons.homeRegular,
              width: 24,
              height: 24,
            ),
            label: 'Venyu',
          ),
          
          // Matches Tab
          BottomNavigationBarItem(
            icon: BadgeWidget(
              count: matchesBadgeCount,
              showBadge: matchesBadgeCount > 0,
              child: AppIconWidget(
                iconPath: _currentIndex == 1 ? AppIcons.coupleSelected : AppIcons.coupleRegular,
                width: 24,
                height: 24,
              ),
            ),
            label: 'Matches',
          ),
          
          // Notifications Tab
          BottomNavigationBarItem(
            icon: BadgeWidget(
              count: notificationsBadgeCount,
              showBadge: notificationsBadgeCount > 0,
              child: AppIconWidget(
                iconPath: _currentIndex == 2 ? AppIcons.notificationSelected : AppIcons.notificationRegular,
                width: 24,
                height: 24,
              ),
            ),
            label: 'Notifications',
          ),
          
          // Profile Tab
          BottomNavigationBarItem(
            icon: BadgeWidget(
              count: profileBadgeCount,
              showBadge: profileBadgeCount > 0,
              child: AppIconWidget(
                iconPath: _currentIndex == 3 ? AppIcons.profileSelected : AppIcons.profileRegular,
                width: 24,
                height: 24,
              ),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}