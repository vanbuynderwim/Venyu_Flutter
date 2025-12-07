import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../l10n/app_localizations.dart';
import '../../core/utils/app_logger.dart';
import '../../core/utils/dialog_utils.dart';
import '../../widgets/common/empty_state_widget.dart';
import '../../widgets/common/warning_box_widget.dart';
import '../../widgets/scaffolds/app_scaffold.dart';
import '../../widgets/common/loading_state_widget.dart';
import 'notification_item_view.dart';
import '../../models/notification.dart' as venyu;
import '../../models/requests/paginated_request.dart';
import '../../services/supabase_managers/notification_manager.dart';
import '../../services/notification_service.dart';
import '../../core/providers/app_providers.dart';
import '../../mixins/paginated_list_view_mixin.dart';
import '../matches/match_detail_view.dart';
import '../prompts/prompt_detail_view.dart';
import 'notification_settings_view.dart';
import '../../core/theme/venyu_theme.dart';

/// NotificationsView - Notifications page with ListView for server data
class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView>
    with PaginatedListViewMixin<NotificationsView>, WidgetsBindingObserver {
  // Services
  late final NotificationManager _notificationManager;
  late final NotificationService _notificationService;

  // State
  final List<venyu.Notification> _notifications = [];
  bool _notificationsEnabled = true; // Assume enabled by default

  @override
  void initState() {
    super.initState();
    AppLogger.debug('NotificationsView initState', context: 'NotificationsView');
    _notificationManager = NotificationManager.shared;
    _notificationService = NotificationService.shared;
    WidgetsBinding.instance.addObserver(this);
    AppLogger.debug('Added WidgetsBindingObserver', context: 'NotificationsView');
    initializePagination();
    _checkNotificationPermission();
    _loadNotifications();
  }

  @override
  void dispose() {
    AppLogger.debug('NotificationsView dispose', context: 'NotificationsView');
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    AppLogger.debug('App lifecycle state changed to: $state', context: 'NotificationsView');
    // Re-check notification permission when app resumes
    if (state == AppLifecycleState.resumed) {
      AppLogger.debug('App resumed - checking notification permission', context: 'NotificationsView');
      _checkNotificationPermission();
    }
  }

  /// Check if notifications are enabled
  Future<void> _checkNotificationPermission() async {
    AppLogger.debug('_checkNotificationPermission called', context: 'NotificationsView');
    try {
      final status = await _notificationService.getPermissionStatus();
      AppLogger.debug('Notification permission status: $status', context: 'NotificationsView');

      final isEnabled = status == AuthorizationStatus.authorized ||
                        status == AuthorizationStatus.provisional;

      AppLogger.debug('Notifications enabled: $isEnabled (was: $_notificationsEnabled)', context: 'NotificationsView');

      if (mounted) {
        setState(() {
          _notificationsEnabled = isEnabled;
        });
        AppLogger.debug('State updated - notificationsEnabled: $_notificationsEnabled', context: 'NotificationsView');
      }
    } catch (error) {
      AppLogger.error('Error checking notification permission', context: 'NotificationsView', error: error);
    }
  }

  @override
  Future<void> loadMoreItems() async {
    await _loadMoreNotifications();
  }

  Future<void> _loadNotifications({bool forceRefresh = false}) async {
    final authService = context.authService;
    if (!authService.isAuthenticated) return;

    if (forceRefresh || _notifications.isEmpty) {
      if (mounted) {
        setState(() {
          isLoading = true;
          if (forceRefresh) {
            _notifications.clear();
            hasMorePages = true;
          }
        });
      }

      try {
        final request = PaginatedRequest(
          limit: PaginatedRequest.numberOfNotifications,
          list: ServerListType.notifications,
        );

        final notifications = await _notificationManager.fetchNotifications(request);
        if (mounted) {
          setState(() {
            _notifications.addAll(notifications);
            hasMorePages = notifications.length == PaginatedRequest.numberOfNotifications;
            isLoading = false;
          });
        }
      } catch (error) {
        AppLogger.error('Error fetching notifications', context: 'NotificationsView', error: error);
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }

  Future<void> _loadMoreNotifications() async {
    if (_notifications.isEmpty || !hasMorePages) return;

    if (mounted) {
      setState(() {
        isLoadingMore = true;
      });
    }

    try {
      final lastNotification = _notifications.last;
      final request = PaginatedRequest(
        limit: PaginatedRequest.numberOfNotifications,
        cursorId: lastNotification.id,
        cursorTime: lastNotification.createdAt,
        list: ServerListType.notifications,
      );

      final notifications = await _notificationManager.fetchNotifications(request);
      if (mounted) {
        setState(() {
          _notifications.addAll(notifications);
          hasMorePages = notifications.length == PaginatedRequest.numberOfNotifications;
          isLoadingMore = false;
        });
      }
    } catch (error) {
      AppLogger.error('Error loading more notifications', context: 'NotificationsView', error: error);
      if (mounted) {
        setState(() {
          isLoadingMore = false;
        });
      }
    }
  }

  Future<void> _handleRefresh() async {
    await _loadNotifications(forceRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AppScaffold(
      appBar: PlatformAppBar(
        title: Text(l10n.navNotifications),
        trailingActions: [
          PlatformIconButton(
            padding: EdgeInsets.zero,
            icon: context.themedIcon('settings'),
            onPressed: () {
              Navigator.push(
                context,
                platformPageRoute(
                  context: context,
                  builder: (context) => const NotificationSettingsView(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Warning box if notifications are disabled
          if (!_notificationsEnabled)
            Padding(
              padding: const EdgeInsets.only(bottom: 8, top: 8),
              child: GestureDetector(
                onTap: () => DialogUtils.openAppSettings(context),
                child: WarningBoxWidget(
                  text: l10n.notificationsDisabledWarning,
                ),
              ),
            ),

          // Main content
          Expanded(
            child: RefreshIndicator(
              onRefresh: _handleRefresh,
              child: isLoading
                  ? const LoadingStateWidget()
                  : _notifications.isEmpty
                      ? CustomScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          slivers: [
                            SliverFillRemaining(
                              child: EmptyStateWidget(
                                message: ServerListType.notifications.emptyStateTitle(context),
                                description: ServerListType.notifications.emptyStateDescription(context),
                                iconName: "notification",
                                height: MediaQuery.of(context).size.height * 0.6,
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          controller: scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: _notifications.length + (isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == _notifications.length) {
                              return buildLoadingIndicator();
                            }

                            final notification = _notifications[index];
                            return NotificationItemView(
                              notification: notification,
                              onNotificationSelected: (selectedNotification) {
                                AppLogger.debug('Notification tapped: ${selectedNotification.title}', context: 'NotificationsView');

                                // Update notification as opened (fire-and-forget)
                                _notificationManager.updateNotification(selectedNotification.id).then((_) {
                                  AppLogger.debug('Notification marked as opened', context: 'NotificationsView');
                                }).catchError((error) {
                                  AppLogger.error('Failed to update notification', context: 'NotificationsView', error: error);
                                });

                                // If notification has a match, navigate to match detail view
                                if (selectedNotification.match != null) {
                                  Navigator.push(
                                    context,
                                    platformPageRoute(
                                      context: context,
                                      builder: (context) => MatchDetailView(
                                        matchId: selectedNotification.match!.id,
                                      ),
                                    ),
                                  );
                                }
                                // If notification has a prompt, navigate to prompt detail view
                                else if (selectedNotification.prompt != null) {
                                  Navigator.push(
                                    context,
                                    platformPageRoute(
                                      context: context,
                                      builder: (context) => PromptDetailView(
                                        promptId: selectedNotification.prompt!.promptID,
                                        interactionType: selectedNotification.prompt!.interactionType,
                                      ),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }
}