import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../core/constants/app_strings.dart';
import '../core/theme/venyu_theme.dart';
import '../core/utils/app_logger.dart';
import '../models/prompt.dart';
import '../services/supabase_managers/content_manager.dart';
import '../services/session_manager.dart';
import 'matches/matches_view.dart';
import 'cards/cards_view.dart';
import 'venues/venues_view.dart';
import 'notifications/notifications_view.dart';
import 'profile/profile_view.dart';
import 'prompts/prompt_entry_view.dart';

/// MainView - Tab navigation using flutter_platform_widgets (based on Test project pattern)
class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final int _currentIndex = 0;
  
  // Services
  late final ContentManager _contentManager;
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
    _contentManager = ContentManager.shared;
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
        AppLogger.info('User not authenticated, skipping prompt check', context: 'MainView');
        return;
      }

      AppLogger.info('Checking for available prompts...', context: 'MainView');
      final prompts = await _contentManager.fetchPrompts();
      
      if (prompts.isNotEmpty && mounted) {
        AppLogger.info('Found ${prompts.length} prompts, showing PromptsView', context: 'MainView');
        _showPromptsModal(prompts);
      } else {
        AppLogger.info('No prompts available', context: 'MainView');
      }
    } catch (error) {
      AppLogger.error('Error fetching prompts', error: error, context: 'MainView');
      // Don't show error to user - just log it and continue normally
    }
  }

  /// Show the PromptEntryView as a fullscreen modal
  Future<void> _showPromptsModal(List<Prompt> prompts) async {
    await showPlatformModalSheet<void>(
      context: context,
      material: MaterialModalSheetData(
        isScrollControlled: true,
        useSafeArea: true,
        isDismissible: true,
      ),
      builder: (context) => PromptEntryView(prompts: prompts),
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