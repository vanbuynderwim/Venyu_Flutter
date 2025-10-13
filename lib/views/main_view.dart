import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../l10n/app_localizations.dart';
import '../core/theme/venyu_theme.dart';
import '../core/utils/app_logger.dart';
import '../models/prompt.dart';
import '../services/supabase_managers/content_manager.dart';
import '../core/providers/app_providers.dart';
import '../services/notification_service.dart';
import '../services/version_service.dart';
import '../services/connectivity_service.dart';
import '../models/badge_data.dart';
import 'matches/matches_view.dart';
import 'prompts/prompts_view.dart';
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
  static bool _hasShownFirstTimePrompts = false; // Track if we've already shown prompts this session
  static bool _hasCheckedPromptsThisSession = false; // Track if we've already checked for prompts this session
  bool _isCheckingPrompts = false; // Prevent multiple simultaneous checks

  // Badge counts
  BadgeData? _badgeData;

  // Tab controller
  late final PlatformTabController _tabController;

  // Services
  late final ContentManager _contentManager;
  late final NotificationService _notificationService;
  
  static const List<Widget> _pages = [
    MatchesView(),
    PromptsView(),
    NotificationsView(),
    ProfileView(),
  ];

  @override
  void initState() {
    super.initState();
    _contentManager = ContentManager.shared;
    _notificationService = NotificationService.shared;
    _tabController = PlatformTabController(initialIndex: 0);

    // Set up badge update callback
    _notificationService.setBadgeUpdateCallback((badgeData) {
      if (mounted) {
        setState(() {
          _badgeData = badgeData;
        });
      }
    });

    // Check for prompts, badges, version, and connectivity on app startup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForPrompts();
      _fetchBadges();
      _checkVersion();
      ConnectivityService.shared.initialize(context);
    });
  }

  /// Check for available prompts and show PromptsView if any are found
  Future<void> _checkForPrompts() async {
    // Skip if we've already checked prompts this session
    if (_hasCheckedPromptsThisSession) {
      AppLogger.debug('Already checked prompts this session, skipping', context: 'MainView');
      return;
    }
    
    // Prevent multiple simultaneous checks
    if (_isCheckingPrompts) {
      AppLogger.debug('Already checking prompts, skipping duplicate check', context: 'MainView');
      return;
    }
    
    _isCheckingPrompts = true;
    _hasCheckedPromptsThisSession = true; // Mark that we've checked this session
    
    try {
      // Only check for prompts if user is authenticated
      final authService = context.authService;
      if (!authService.isAuthenticated) {
        AppLogger.info('User not authenticated, skipping prompt check', context: 'MainView');
        return;
      }

      AppLogger.info('Checking for available prompts...', context: 'MainView');
      final prompts = await _contentManager.fetchPrompts();
      
      if (prompts.isNotEmpty && mounted) {
        AppLogger.info('Found ${prompts.length} prompts, showing PromptsView', context: 'MainView');
        await _showPromptsModal(prompts);
      } else {
        AppLogger.info('No prompts available', context: 'MainView');
      }
    } catch (error) {
      AppLogger.error('Error fetching prompts', error: error, context: 'MainView');
      // Don't show error to user - just log it and continue normally
    } finally {
      _isCheckingPrompts = false;
    }
  }

  /// Show the PromptEntryView as a fullscreen modal
  Future<void> _showPromptsModal(List<Prompt> prompts) async {
    
    void closeModalCallback() {
      // Pop all routes (including modal) until we're back at MainView level
      Navigator.of(context).popUntil((route) => route.isFirst);
    }

    await showPlatformModalSheet<void>(
      context: context,
      material: MaterialModalSheetData(
        useRootNavigator: false,
        isScrollControlled: true,
        useSafeArea: true,
        isDismissible: true,
      ),
      cupertino: CupertinoModalSheetData(
        useRootNavigator: false,
        barrierDismissible: true,
      ),
      builder: (sheetCtx) => PromptEntryView(
        prompts: prompts,
        isModal: true, // Geef aan dat dit in een modal is
        onCloseModal: closeModalCallback,
      ),
    );
  }
  
  /// Fetch badge counts for tab bar items
  Future<void> _fetchBadges() async {
    try {
      final badges = await _notificationService.fetchBadges();
      if (badges != null && mounted) {
        setState(() {
          _badgeData = badges;
        });
      }
    } catch (error) {
      AppLogger.error('Failed to fetch badges', error: error, context: 'MainView');
    }
  }

  /// Check for app version updates
  Future<void> _checkVersion() async {
    try {
      if (mounted) {
        await VersionService.shared.checkVersion(context);
      }
    } catch (error) {
      AppLogger.error('Failed to check version', error: error, context: 'MainView');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    ConnectivityService.shared.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformTabScaffold(
      tabController: _tabController,
      items: [
        BottomNavigationBarItem(
          icon: _badgeData != null && _badgeData!.matchesCount > 0
              ? Badge.count(
                  count: _badgeData!.matchesCount,
                  child: context.themedIcon('handshake', selected: false),
                )
              : context.themedIcon('handshake', selected: false),
          activeIcon: _badgeData != null && _badgeData!.matchesCount > 0
              ? Badge.count(
                  count: _badgeData!.matchesCount,
                  child: context.themedIcon('handshake', selected: true),
                )
              : context.themedIcon('handshake', selected: true),
          label: AppLocalizations.of(context)!.navMatches,
        ),
        BottomNavigationBarItem(
          icon: context.themedIcon('card', selected: false),
          activeIcon: context.themedIcon('card', selected: true),
          label: AppLocalizations.of(context)!.navCards,
        ),
        BottomNavigationBarItem(
          icon: _badgeData != null && _badgeData!.unreadNotifications > 0
              ? Badge.count(
                  count: _badgeData!.unreadNotifications,
                  child: context.themedIcon('notification', selected: false),
                )
              : context.themedIcon('notification', selected: false),
          activeIcon: _badgeData != null && _badgeData!.unreadNotifications > 0
              ? Badge.count(
                  count: _badgeData!.unreadNotifications,
                  child: context.themedIcon('notification', selected: true),
                )
              : context.themedIcon('notification', selected: true),
          label: AppLocalizations.of(context)!.navNotifications,
        ),
        BottomNavigationBarItem(
          icon: _badgeData != null && (_badgeData!.totalReviews + _badgeData!.invitesCount) > 0
              ? Badge.count(
                  count: _badgeData!.totalReviews + _badgeData!.invitesCount,
                  child: context.themedIcon('profile', selected: false),
                )
              : context.themedIcon('profile', selected: false),
          activeIcon: _badgeData != null && (_badgeData!.totalReviews + _badgeData!.invitesCount) > 0
              ? Badge.count(
                  count: _badgeData!.totalReviews + _badgeData!.invitesCount,
                  child: context.themedIcon('profile', selected: true),
                )
              : context.themedIcon('profile', selected: true),
          label: AppLocalizations.of(context)!.navProfile,
        ),
      ],
      bodyBuilder: (context, index) => _pages[index],
    );
  }
}