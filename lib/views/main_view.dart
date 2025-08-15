import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../core/constants/app_strings.dart';
import '../core/theme/venyu_theme.dart';
import '../models/prompt.dart';
import '../services/supabase_manager.dart';
import '../services/session_manager.dart';
import 'matches/matches_view.dart';
import 'cards/cards_view.dart';
import 'venues/venues_view.dart';
import 'notifications/notifications_view.dart';
import 'profile/profile_view.dart';
import 'prompts/prompts_view.dart';

/// MainView - Tab navigation using flutter_platform_widgets (based on Test project pattern)
class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final int _currentIndex = 0;
  
  // Services
  late final SupabaseManager _supabaseManager;
  late final SessionManager _sessionManager;
  
  static const List<Widget> _pages = [
    MatchesView(),
    CardsView(),
    VenuesView(),
    NotificationsView(),
    ProfileView(),
  ];

  @override
  void initState() {
    super.initState();
    _supabaseManager = SupabaseManager.shared;
    _sessionManager = SessionManager.shared;
    
    // Check for prompts on app startup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForPrompts();
    });
  }

  /// Check for available prompts and show PromptsView if any are found
  Future<void> _checkForPrompts() async {
    try {
      // Only check for prompts if user is authenticated
      if (!_sessionManager.isAuthenticated) {
        debugPrint('MainView: User not authenticated, skipping prompt check');
        return;
      }

      debugPrint('MainView: Checking for available prompts...');
      final prompts = await _supabaseManager.fetchPrompts();
      
      if (prompts.isNotEmpty && mounted) {
        debugPrint('MainView: Found ${prompts.length} prompts, showing PromptsView');
        _showPromptsModal(prompts);
      } else {
        debugPrint('MainView: No prompts available');
      }
    } catch (error) {
      debugPrint('MainView: Error fetching prompts: $error');
      // Don't show error to user - just log it and continue normally
    }
  }

  /// Show the PromptsView as a fullscreen modal
  Future<void> _showPromptsModal(List<Prompt> prompts) async {
    await showPlatformModalSheet<void>(
      context: context,
      material: MaterialModalSheetData(
        isScrollControlled: true,
        useSafeArea: true,
        isDismissible: true,
      ),
      builder: (context) => PromptsView(prompts: prompts),
    );
  }

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
          icon: context.themedIcon('card', selected: false),
          activeIcon: context.themedIcon('card', selected: true),
          label: AppStrings.cards,
        ),
        BottomNavigationBarItem(
          icon: context.themedIcon('venue', selected: false),
          activeIcon: context.themedIcon('venue', selected: true),
          label: AppStrings.venues,
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