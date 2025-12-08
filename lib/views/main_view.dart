import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:location/location.dart';

import '../l10n/app_localizations.dart';
import '../core/theme/venyu_theme.dart';
import '../core/utils/app_logger.dart';
import '../models/prompt.dart';
import '../services/supabase_managers/content_manager.dart';
import '../services/supabase_managers/profile_manager.dart';
import '../core/providers/app_providers.dart';
import '../services/notification_service.dart';
import '../services/version_service.dart';
import '../services/connectivity_service.dart';
import '../services/deep_link_service.dart';
import '../services/tutorial_service.dart';
import '../models/badge_data.dart';
import 'matches/matches_view.dart';
import 'prompts/prompts_view.dart';
import 'notifications/notifications_view.dart';
import 'profile/profile_view.dart';
import 'prompts/prompt_entry_view.dart';
import 'onboarding/returning_user_tutorial_view.dart';

/// MainView - Tab navigation using flutter_platform_widgets (based on Test project pattern)
class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  static bool _hasCheckedPromptsThisSession = false; // Track if we've already checked for prompts this session
  static bool _hasCheckedTutorialThisSession = false; // Track if we've already checked for tutorial this session
  bool _isCheckingPrompts = false; // Prevent multiple simultaneous checks
  bool _isCheckingTutorial = false; // Prevent multiple simultaneous tutorial checks

  // Badge counts
  BadgeData? _badgeData;
  int _availablePromptsCount = 0;

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

    // Set up available prompts update callback
    _contentManager.addAvailablePromptsCallback(_onAvailablePromptsUpdate);

    // Set up deep link navigation callback
    DeepLinkService.shared.setNavigateToTabCallback(_navigateToTab);

    // Check for tutorial, prompts, badges, version, connectivity, and permissions on app startup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndRequestPermissions();
      _checkForReturningUserTutorial(); // Check tutorial BEFORE prompts
      _fetchBadges();
      _checkVersion();
      ConnectivityService.shared.initialize(context);
    });
  }

  /// Callback for available prompts updates
  void _onAvailablePromptsUpdate(List<Prompt> prompts) {
    if (mounted) {
      setState(() {
        _availablePromptsCount = prompts.length;
      });
    }
  }

  /// Navigate to a specific tab (used by deep link service)
  void _navigateToTab(int tabIndex) {
    if (mounted && tabIndex >= 0 && tabIndex < _pages.length) {
      AppLogger.info('Navigating to tab $tabIndex via deep link', context: 'MainView');
      _tabController.setIndex(context, tabIndex);
    }
  }

  /// Check if returning user needs to see the updated tutorial
  ///
  /// This shows the tutorial modal for existing users after an app update
  /// that changed the rules. It runs BEFORE the prompts check.
  Future<void> _checkForReturningUserTutorial() async {
    // Skip if we've already checked tutorial this session
    if (_hasCheckedTutorialThisSession) {
      AppLogger.debug('Already checked tutorial this session, proceeding to prompts', context: 'MainView');
      _checkForPrompts();
      return;
    }

    // Prevent multiple simultaneous checks
    if (_isCheckingTutorial) {
      AppLogger.debug('Already checking tutorial, skipping duplicate check', context: 'MainView');
      return;
    }

    _isCheckingTutorial = true;
    _hasCheckedTutorialThisSession = true;

    try {
      // Only check for registered users (registeredAt != null)
      final authService = context.authService;
      if (!authService.isAuthenticated) {
        AppLogger.info('User not authenticated, skipping tutorial check', context: 'MainView');
        _checkForPrompts();
        return;
      }

      final profileService = context.profileService;
      final profile = profileService.currentProfile;

      // Only show tutorial for existing users (those who have registered)
      if (profile?.registeredAt == null) {
        AppLogger.info('User not registered yet, skipping returning user tutorial', context: 'MainView');
        _checkForPrompts();
        return;
      }

      // Check if user needs to see the tutorial
      final needsTutorial = await TutorialService.shared.needsToShowTutorial();

      if (needsTutorial && mounted) {
        AppLogger.info('Showing returning user tutorial', context: 'MainView');
        await _showReturningUserTutorialModal();
        // After tutorial is done, check for prompts
        _checkForPrompts();
      } else {
        AppLogger.debug('Tutorial already shown or not needed', context: 'MainView');
        _checkForPrompts();
      }
    } catch (error) {
      AppLogger.error('Error checking for returning user tutorial', error: error, context: 'MainView');
      // Continue to prompts check even on error
      _checkForPrompts();
    } finally {
      _isCheckingTutorial = false;
    }
  }

  /// Show the ReturningUserTutorialView as a fullscreen modal
  Future<void> _showReturningUserTutorialModal() async {
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
        isDismissible: false, // Don't allow dismissing by tapping outside
      ),
      cupertino: CupertinoModalSheetData(
        useRootNavigator: false,
        barrierDismissible: false, // Don't allow dismissing by tapping outside
      ),
      builder: (sheetCtx) => ReturningUserTutorialView(
        onCloseModal: closeModalCallback,
      ),
    );
  }

  /// Check and request missing permissions for returning users
  ///
  /// This handles the case where a user reinstalls the app:
  /// - iOS resets all permissions after app deletion
  /// - User is already registered (skips onboarding)
  /// - We need to re-request location and notification permissions
  Future<void> _checkAndRequestPermissions() async {
    try {
      // 1. Check and request location permission
      final location = Location();
      final locationPermission = await location.hasPermission();

      if (locationPermission != PermissionStatus.granted &&
          locationPermission != PermissionStatus.grantedLimited) {
        AppLogger.info(
          'Location permission missing for returning user, requesting...',
          context: 'MainView',
        );

        final granted = await location.requestPermission();

        if (granted == PermissionStatus.granted ||
            granted == PermissionStatus.grantedLimited) {
          AppLogger.success('Location permission granted', context: 'MainView');

          // Now that we have permission, refresh the location
          await ProfileManager.shared.refreshLocationAtStartup();
        } else {
          AppLogger.info('Location permission denied', context: 'MainView');
        }
      }

      // 2. Request notification permission
      // Note: iOS won't show dialog if permission is already granted
      AppLogger.info(
        'Checking notification permission for returning user...',
        context: 'MainView',
      );

      final granted = await _notificationService.requestPermission();

      if (granted) {
        AppLogger.success('Notification permission granted', context: 'MainView');
      } else {
        AppLogger.info('Notification permission denied or already denied', context: 'MainView');
      }
    } catch (error) {
      AppLogger.error(
        'Error checking/requesting permissions',
        error: error,
        context: 'MainView',
      );
      // Don't block app startup if permission check fails
    }
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

      // The badge count is automatically updated via callback
      // Only show modal if there are prompts
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
        isModal: true,
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
    _contentManager.removeAvailablePromptsCallback(_onAvailablePromptsUpdate);
    DeepLinkService.shared.setNavigateToTabCallback(null);
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
                  child: context.themedIcon('match', selected: false),
                )
              : context.themedIcon('match', selected: false),
          activeIcon: _badgeData != null && _badgeData!.matchesCount > 0
              ? Badge.count(
                  count: _badgeData!.matchesCount,
                  child: context.themedIcon('match', selected: true),
                )
              : context.themedIcon('match', selected: true),
          label: AppLocalizations.of(context)!.navMatches,
        ),
        BottomNavigationBarItem(
          icon: _availablePromptsCount > 0
              ? Badge.count(
                  count: _availablePromptsCount,
                  child: context.themedIcon('request', selected: false),
                )
              : context.themedIcon('request', selected: false),
          activeIcon: _availablePromptsCount > 0
              ? Badge.count(
                  count: _availablePromptsCount,
                  child: context.themedIcon('request', selected: true),
                )
              : context.themedIcon('request', selected: true),
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