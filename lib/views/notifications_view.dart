import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../core/constants/app_strings.dart';
import '../widgets/common/empty_state_widget.dart';
import '../widgets/scaffolds/app_scaffold.dart';
import '../widgets/notifications/notification_item_view.dart';
import '../models/notification.dart' as venyu;
import '../models/requests/paginated_request.dart';
import '../services/supabase_manager.dart';
import '../services/session_manager.dart';
import 'matches/match_detail_view.dart';

/// NotificationsView - Notifications page with ListView for server data
class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  final List<venyu.Notification> _notifications = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMorePages = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadNotifications();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        _hasMorePages) {
      _loadMoreNotifications();
    }
  }

  Future<void> _loadNotifications({bool forceRefresh = false}) async {
    if (!SessionManager.shared.isAuthenticated) return;

    if (forceRefresh || _notifications.isEmpty) {
      setState(() {
        _isLoading = true;
        if (forceRefresh) {
          _notifications.clear();
          _hasMorePages = true;
        }
      });

      try {
        final request = PaginatedRequest(
          limit: PaginatedRequest.numberOfNotifications,
          list: ServerListType.notifications,
        );

        final notifications = await SupabaseManager.shared.fetchNotifications(request);
        setState(() {
          _notifications.addAll(notifications);
          _hasMorePages = notifications.length == PaginatedRequest.numberOfNotifications;
          _isLoading = false;
        });
      } catch (error) {
        debugPrint('Error fetching notifications: $error');
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadMoreNotifications() async {
    if (_notifications.isEmpty || !_hasMorePages) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final lastNotification = _notifications.last;
      final request = PaginatedRequest(
        limit: PaginatedRequest.numberOfNotifications,
        cursorId: lastNotification.id,
        cursorTime: lastNotification.createdAt,
        list: ServerListType.notifications,
      );

      final notifications = await SupabaseManager.shared.fetchNotifications(request);
      setState(() {
        _notifications.addAll(notifications);
        _hasMorePages = notifications.length == PaginatedRequest.numberOfNotifications;
        _isLoadingMore = false;
      });
    } catch (error) {
      debugPrint('Error loading more notifications: $error');
      setState(() {
        _isLoadingMore = false;
      });
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
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _notifications.isEmpty
                ? CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverFillRemaining(
                        child: EmptyStateWidget(
                          message: ServerListType.notifications.emptyStateTitle,
                          description: ServerListType.notifications.emptyStateDescription,
                          iconName: ServerListType.notifications.emptyStateIcon,
                          height: MediaQuery.of(context).size.height * 0.6,
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: _notifications.length + (_isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _notifications.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final notification = _notifications[index];
                      return NotificationItemView(
                        notification: notification,
                        onNotificationSelected: (selectedNotification) {
                          debugPrint('Tapped on notification: ${selectedNotification.title}');
                          
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