import 'dart:async';
import 'package:flutter/material.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../core/utils/app_logger.dart';
import '../views/matches/match_detail_view.dart';
import '../views/prompts/prompt_detail_view.dart';
import '../views/profile/profile_view.dart';

/// DeepLinkService - Handles deep linking for the app
///
/// Early bootstrap approach to prevent iOS from falling back to Safari.
/// The service registers the listener BEFORE the app is fully initialized,
/// queues incoming links, and processes them when the navigator is ready.
///
/// Supports the following deep link patterns:
/// - https://app.getvenyu.com/match/{matchId}
/// - https://app.getvenyu.com/prompt/{promptId}
/// - https://app.getvenyu.com/profile/{profileId}
class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  static DeepLinkService get shared => _instance;

  DeepLinkService._internal();

  final AppLinks _appLinks = AppLinks();
  final List<Uri> _pendingLinks = [];
  StreamSubscription<Uri>? _subscription;
  BuildContext? _context;
  bool _earlyBootstrapDone = false;

  /// Call VERY early (before runApp) to register the listener immediately.
  /// This ensures iOS sees an active handler and doesn't fall back to Safari.
  Future<void> earlyBootstrap() async {
    if (_earlyBootstrapDone) return;
    _earlyBootstrapDone = true;

    AppLogger.info('Early bootstrap: registering deep link listener', context: 'DeepLinkService');

    // 1) Subscribe ASAP so iOS sees an active handler
    _subscription = _appLinks.uriLinkStream.listen(
      (Uri uri) {
        AppLogger.info('Deep link queued: $uri', context: 'DeepLinkService');
        _pendingLinks.add(uri);
        _drainQueue();
      },
      onError: (error) {
        AppLogger.error(
          'Deep link stream error',
          error: error,
          context: 'DeepLinkService',
        );
      },
    );

    // 2) Grab the initial link ASAP (cold start from Universal Link)
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        AppLogger.info('Initial deep link queued: $initialUri', context: 'DeepLinkService');
        _pendingLinks.add(initialUri);
      }
    } catch (e) {
      AppLogger.error(
        'Failed to get initial link',
        error: e,
        context: 'DeepLinkService',
      );
    }
  }

  /// Call when navigator/context is ready (after app is registered).
  /// This will process any queued links.
  void attachContext(BuildContext context) {
    AppLogger.info('Attaching context to DeepLinkService', context: 'DeepLinkService');
    _context = context;
    _drainQueue();
  }

  /// Process queued deep links when context becomes available.
  /// Avoids duplicates (Notes/iMessage can send duplicate events).
  void _drainQueue() {
    if (_context == null || _pendingLinks.isEmpty) return;

    AppLogger.info('Draining ${_pendingLinks.length} queued deep links', context: 'DeepLinkService');

    // Process all queued links, avoiding duplicates
    final handled = <String>{};
    while (_pendingLinks.isNotEmpty) {
      final uri = _pendingLinks.removeAt(0);
      final key = uri.toString();

      if (handled.contains(key)) {
        AppLogger.info('Skipping duplicate deep link: $uri', context: 'DeepLinkService');
        continue;
      }

      handled.add(key);
      _handleDeepLink(uri);
    }
  }

  /// Handle incoming deep link URIs
  void _handleDeepLink(Uri uri) {
    AppLogger.info('=== HANDLING DEEP LINK START ===', context: 'DeepLinkService');
    AppLogger.info('URI: $uri', context: 'DeepLinkService');
    AppLogger.info('Scheme: ${uri.scheme}, Host: ${uri.host}, Path: ${uri.path}', context: 'DeepLinkService');

    if (_context == null) {
      AppLogger.warning(
        'Cannot handle deep link: context not available (this should not happen)',
        context: 'DeepLinkService',
      );
      return;
    }

    // Only handle HTTPS Universal Links, ignore custom URL schemes
    // Custom schemes (com.getvenyu.app://) are for OAuth callbacks only
    if (uri.scheme != 'https') {
      AppLogger.info(
        'Ignoring non-HTTPS deep link (likely OAuth callback): $uri',
        context: 'DeepLinkService',
      );
      AppLogger.info('=== HANDLING DEEP LINK END (ignored - non-HTTPS) ===', context: 'DeepLinkService');
      return;
    }

    // Only handle links from our domain
    if (uri.host != 'app.getvenyu.com') {
      AppLogger.warning(
        'Ignoring deep link from unknown host: ${uri.host}',
        context: 'DeepLinkService',
      );
      AppLogger.info('=== HANDLING DEEP LINK END (ignored - wrong host) ===', context: 'DeepLinkService');
      return;
    }

    // CRITICAL: Let Supabase handle its own auth callback paths
    // Do NOT handle /auth/* paths - these are for Supabase OAuth
    if (uri.path.startsWith('/auth/')) {
      AppLogger.info(
        'Ignoring auth callback path (handled by Supabase): $uri',
        context: 'DeepLinkService',
      );
      AppLogger.info('=== HANDLING DEEP LINK END (ignored - Supabase auth) ===', context: 'DeepLinkService');
      return;
    }

    AppLogger.info('Processing deep link: $uri', context: 'DeepLinkService');

    // Parse the path and navigate accordingly
    final pathSegments = uri.pathSegments;

    if (pathSegments.isEmpty) {
      AppLogger.warning(
        'Deep link has no path segments: $uri',
        context: 'DeepLinkService',
      );
      return;
    }

    final firstSegment = pathSegments.first;

    switch (firstSegment) {
      case 'match':
        _handleMatchDeepLink(pathSegments);
        break;
      case 'prompt':
        _handlePromptDeepLink(pathSegments);
        break;
      case 'profile':
        _handleProfileDeepLink(pathSegments);
        break;
      default:
        AppLogger.warning(
          'Unhandled deep link path: $firstSegment',
          context: 'DeepLinkService',
        );
    }

    AppLogger.info('=== HANDLING DEEP LINK END ===', context: 'DeepLinkService');
  }

  /// Handle match deep links: /match/{matchId}
  void _handleMatchDeepLink(List<String> pathSegments) {
    if (pathSegments.length < 2) {
      AppLogger.warning(
        'Match deep link missing ID',
        context: 'DeepLinkService',
      );
      return;
    }

    final matchId = pathSegments[1];
    AppLogger.info('Navigating to match: $matchId', context: 'DeepLinkService');

    Navigator.push(
      _context!,
      platformPageRoute(
        context: _context!,
        builder: (_) => MatchDetailView(matchId: matchId),
      ),
    );
  }

  /// Handle prompt deep links: /prompt/{promptId}
  void _handlePromptDeepLink(List<String> pathSegments) {
    if (pathSegments.length < 2) {
      AppLogger.warning(
        'Prompt deep link missing ID',
        context: 'DeepLinkService',
      );
      return;
    }

    final promptId = pathSegments[1];
    AppLogger.info(
      'Navigating to prompt: $promptId',
      context: 'DeepLinkService',
    );

    Navigator.push(
      _context!,
      platformPageRoute(
        context: _context!,
        builder: (_) => PromptDetailView(promptId: promptId),
      ),
    );
  }

  /// Handle profile deep links: /profile/{profileId}
  void _handleProfileDeepLink(List<String> pathSegments) {
    if (pathSegments.length < 2) {
      AppLogger.warning(
        'Profile deep link missing ID',
        context: 'DeepLinkService',
      );
      return;
    }

    final profileId = pathSegments[1];
    AppLogger.info(
      'Navigating to profile: $profileId',
      context: 'DeepLinkService',
    );

    // TODO: For now, navigate to the current user's profile view
    // In the future, we might want to add a PublicProfileView that can show any user's profile by ID
    Navigator.push(
      _context!,
      platformPageRoute(
        context: _context!,
        builder: (_) => const ProfileView(),
      ),
    );
  }

  /// Dispose of resources
  Future<void> dispose() async {
    await _subscription?.cancel();
    _subscription = null;
    _context = null;
    _pendingLinks.clear();
  }
}
