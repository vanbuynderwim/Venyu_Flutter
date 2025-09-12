import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../core/constants/app_strings.dart';
import '../../core/utils/app_logger.dart';
import '../../widgets/common/empty_state_widget.dart';
import '../../widgets/scaffolds/app_scaffold.dart';
import '../../widgets/common/loading_state_widget.dart';
import 'notification_item_view.dart';
import '../../models/notification.dart' as venyu;
import '../../models/requests/paginated_request.dart';
import '../../services/supabase_managers/matching_manager.dart';
import '../../core/providers/app_providers.dart';
import '../../mixins/paginated_list_view_mixin.dart';
import '../matches/match_detail_view.dart';

/// NotificationsView - Notifications page with ListView for server data
class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> 
    with PaginatedListViewMixin<NotificationsView> {
  // Services
  late final MatchingManager _matchingManager;
  
  // State
  final List<venyu.Notification> _notifications = [];

  @override
  void initState() {
    super.initState();
    _matchingManager = MatchingManager.shared;
    initializePagination();
    _loadNotifications();
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

        final notifications = await _matchingManager.fetchNotifications(request);
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

      final notifications = await _matchingManager.fetchNotifications(request);
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
    return AppScaffold(
      appBar: PlatformAppBar(
        title: Text(AppStrings.notifications),
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: isLoading
            ? const LoadingStateWidget()
            : _notifications.isEmpty
                ? CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverFillRemaining(
                        child: EmptyStateWidget(
                          message: ServerListType.notifications.emptyStateTitle,
                          description: ServerListType.notifications.emptyStateDescription,
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
                          // TODO: Handle other notification types (prompt, etc.)
                        },
                      );
                    },
                  ),
      ),
    );
  }
}