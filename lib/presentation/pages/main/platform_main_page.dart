import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import '../../../shared/widgets/custom_tab_bar.dart';
import '../feed/platform_feed_page.dart';
import '../matches/matches_page.dart';
import '../notifications/notifications_page.dart';
import '../profile/profile_page.dart';

class PlatformMainPage extends StatefulWidget {
  const PlatformMainPage({super.key});

  @override
  State<PlatformMainPage> createState() => _PlatformMainPageState();
}

class _PlatformMainPageState extends State<PlatformMainPage> {
  int _currentIndex = 0;
  
  // TODO: Deze waardes komen later uit een state management systeem
  int matchesBadgeCount = 3;
  int notificationsBadgeCount = 5;
  int profileBadgeCount = 1;

  final List<Widget> _pages = [
    const PlatformFeedPage(),
    const MatchesPage(),
    const NotificationsPage(),
    const ProfilePage(),
  ];

  void _onTabTapped(int index) {
    if (index != _currentIndex) {
      // Haptic feedback bij tab switch
      if (Platform.isIOS) {
        HapticFeedback.selectionClick();
      } else {
        HapticFeedback.lightImpact();
      }
      
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return _buildCupertinoScaffold();
    } else {
      return _buildMaterialScaffold();
    }
  }

  Widget _buildCupertinoScaffold() {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: CustomTabBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        matchesBadgeCount: matchesBadgeCount,
        notificationsBadgeCount: notificationsBadgeCount,
        profileBadgeCount: profileBadgeCount,
      ),
    );
  }

  Widget _buildMaterialScaffold() {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: CustomTabBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        matchesBadgeCount: matchesBadgeCount,
        notificationsBadgeCount: notificationsBadgeCount,
        profileBadgeCount: profileBadgeCount,
      ),
    );
  }
}